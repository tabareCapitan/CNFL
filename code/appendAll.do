/*******************************************************************************
Project:
                                                                                PENDING

Authors:
TabareCapitan.com

Description:


Created: 20180129 | Last modified: 20190804
*******************************************************************************/
version 14.2

clear
*** CONTROL ********************************************************************

cap erase "$RUTA\data\control.dta"

use "$RUTA\data\temp\tr_suc_10_2011", clear

drop if year == 2011

forvalues j = 10(10)50{

  forvalues i = 2011(1)2015{

    di "Current :" `i' " - " `j'

    quietly append using "$RUTA\data\temp\tr_suc_`j'_`i'.dta", force            // should work without force, try?

    di "EXTRA"

    quietly append using "$RUTA\data\temp\raw_`i'_`j'_TR_extraPanel.dta", force // should work without force, try?

  }
}

* Handle Zeros and Missing values (Part 1) -------------------------------------

replace consumption  = 100000 if consumption  == .


* Resolve duplicates -----------------------------------------------------------

gen mes = ""
  replace mes = "JAN" if month == 1
  replace mes = "FEB" if month == 2
  replace mes = "MAR" if month == 3
  replace mes = "APR" if month == 4
  replace mes = "MAY" if month == 5
  replace mes = "JUN" if month == 6
  replace mes = "JUL" if month == 7
  replace mes = "AUG" if month == 8
  replace mes = "SEP" if month == 9
  replace mes = "OCT" if month == 10
  replace mes = "NOV" if month == 11
  replace mes = "DEC" if month == 12


gen unique = string(year) + mes  + string(contract, "%11.0g")

// drop meter
collapse (first) year (first) sucursal (first) timeBlock (sum) consumption      /// UNRESOLVED: same contract could have different meter
         (firstnm) provincia (firstnm) canton (firstnm) distrito                ///
         (firstnm) location  (first) contract (mean) month (first) treatment    /// POTENTIAL ISSUE: same contract with different locations?
         , by(unique)

* Handle Zeros and Missing values (Part 2) -------------------------------------

replace consumption = consumption - 300000 if consumption > 300000
replace consumption = . if consumption == 300000

replace consumption = consumption - 200000 if consumption > 200000
replace consumption = . if consumption == 200000

replace consumption = consumption - 100000 if consumption > 100000
replace consumption = . if consumption == 100000


sort contract year month

* SAVE -------------------------------------------------------------------------

save "$RUTA\data\control.dta", replace


*** TREATMENT ******************************************************************

cap erase "$RUTA\data\treatment.dta"

use "$RUTA\data\temp\trh_6_suc_10_2011", clear

drop if year == 2011

forvalues i = 6(1)8{

  forvalues j = 10(10)50{

    forvalues k = 2011(1)2015{

      di "CURRENT: "`k' "-" `j' "-" `i'

      append using "$RUTA\data\temp\trh_`i'_suc_`j'_`k'", force

      append using "$RUTA\data\temp\raw_`k'_`j'_`i'_TRH_extraPanel.dta"         ///
        , force

    }
  }
}

* Handle Zeros and Missing values (Part 1) -------------------------------------

replace consumption  = 100000 if consumption  == .


* Resolve duplicates -----------------------------------------------------------

gen mes = ""
  replace mes = "JAN" if month == 1
  replace mes = "FEB" if month == 2
  replace mes = "MAR" if month == 3
  replace mes = "APR" if month == 4
  replace mes = "MAY" if month == 5
  replace mes = "JUN" if month == 6
  replace mes = "JUL" if month == 7
  replace mes = "AUG" if month == 8
  replace mes = "SEP" if month == 9
  replace mes = "OCT" if month == 10
  replace mes = "NOV" if month == 11
  replace mes = "DEC" if month == 12


gen unique1 = string(timeBlock) + string(year) + mes  + string(contract, "%11.0g")

gen unique = string(year) + mes  + string(contract, "%11.0g")


duplicates drop

// drop meter
collapse (first) year (first) sucursal (first) timeBlock (sum) consumption      /// UNRESOLVED: same contract could have different meter
         (firstnm) provincia (firstnm) canton (firstnm) distrito                ///
         (firstnm) location  (first) contract (mean) month (first) unique       /// POTENTIAL ISSUE: same contract with different locations?
         (first) treatment                                                      ///
         , by(unique1)

* Handle Zeros and Missing values (Part 2) -------------------------------------

replace consumption = consumption - 300000 if consumption > 300000
replace consumption = . if consumption == 300000

replace consumption = consumption - 200000 if consumption > 200000
replace consumption = . if consumption == 200000

replace consumption = consumption - 100000 if consumption > 100000
replace consumption = . if consumption == 100000

*

sort contract year month timeBlock

drop unique1


* SAVE -------------------------------------------------------------------------

save "$RUTA\data\treatment.dta", replace


*** BOTH ***********************************************************************


* COLLAPSE TREATMENT -----------------------------------------------------------

use "$RUTA\data\treatment.dta", clear

collapse (first) year (first) sucursal (first) timeBlock (sum) consumption      /// UNRESOLVED: same contract could have different meter
         (firstnm) provincia (firstnm) canton (firstnm) distrito                ///
         (firstnm) location  (first) contract (mean) month (first) treatment    /// POTENTIAL ISSUE: same contract with different locations?
         , by(unique)

* APPEND BOTH TREATMENTS -------------------------------------------------------

append using "$RUTA\data\control.dta"

drop timeBlock

* EXTRACT GROUPS OF DUPLICATES  ------------------------------------------------

*** GROUP 1: Pair where one is missing and the other is not

sort contract year month treatment    // needed for commands below

gen pair = 0
replace  pair = 1 if ( unique == unique[_n+1] ) &                               ///
           (( consumption[_n] == . ) | ( consumption[_n+1] == . ))
replace  pair = 1 if ( unique == unique[_n-1] ) &                               ///
           (( consumption[_n] == . ) | ( consumption[_n-1] == . ))

savesome using "$RUTA\data\temp\g1.dta" if pair == 1, replace

drop if pair == 1


*** GROUP 2: pair where one is zero and the other is not

gen pair2 = 0

replace  pair2 = 1 if ( unique == unique[_n+1] ) &                              ///
           (( consumption[_n] == 0 ) | ( consumption[_n+1] == 0 ))
replace  pair2 = 1 if ( unique == unique[_n-1] ) &                              ///
           (( consumption[_n] == 0 ) | ( consumption[_n-1] == 0 ))

savesome using "$RUTA\data\temp\g2.dta" if pair2 == 1, replace

drop if pair2 == 1

*** GROUP 3: pair where both are values > 0

duplicates tag unique, gen(tag)

savesome using "$RUTA\data\temp\g3.dta" if tag == 1, replace

drop if tag == 1

save "$RUTA\data\temp\tempBoth.dta", replace

* REMOVE DUPLICATES ------------------------------------------------------------

*** GROUP 1

use "$RUTA\data\temp\g1.dta", clear

// all the pairs when one is missing are from treatment
* count if treatment == 1 & consumption == .

collapse (mean) pair (mean) treatment (mean) year (mean) sucursal               ///
         (mean) consumption (firstnm) provincia  (firstnm) canton               ///
         (firstnm) distrito (mean) location  (mean) contract (mean) month       ///
         , by(unique)

replace treatment = 1

save "$RUTA\data\temp\g1NoDuplicates.dta", replace

*** GROUP 2

use "$RUTA\data\temp\g2.dta", clear


// Drop if both in the pair are zero

gen zero = 0

replace  zero = 1 if ( unique == unique[_n+1] ) &                                ///
           (( consumption[_n] == 0 ) & ( consumption[_n+1] == 0 ))
replace  zero = 1 if ( unique == unique[_n-1] ) &                               ///
           (( consumption[_n] == 0 ) & ( consumption[_n-1] == 0 ))


drop if zero == 1

// All but 4 cases hava values from control
* count if treatment == 0 & consumption == 0

// Collapse pairs

replace consumption = . if consumption == 0

collapse (mean) pair (mean) treatment (mean) year (mean) sucursal               ///
         (mean) consumption (firstnm) provincia  (firstnm) canton               ///
         (firstnm) distrito (mean) location  (mean) contract (mean) month       ///
         , by(unique)

replace treatment = 0

// fix exceptions

replace treatment = 1 if unique == "2011DEC88844"  |                            ///
                         unique == "2011JUN256843" |                            ///
                         unique == "2012SEP265395" |                            ///
                         unique == "2013OCT447130"


save "$RUTA\data\temp\g2NoDuplicates.dta", replace

*** GROUP 3

*use "$RUTA\data\temp\g3.dta", clear

// Not sure how to deal with this. Maybe I need info from meter or contractStart

*save "$RUTA\data\temp\g3NoDuplicates.dta", replace


* RE-APPEND GROUPS -------------------------------------------------------------

use "$RUTA\data\temp\tempBoth.dta", clear

append using "$RUTA\data\temp\g1NoDuplicates.dta"

append using "$RUTA\data\temp\g2NoDuplicates.dta"

*append using "$RUTA\data\temp\g3NoDuplicates.dta"

drop tag pair pair2


* SAVE -------------------------------------------------------------------------

save "$RUTA\data\both.dta", replace

*** END OF FILE ****************************************************************
********************************************************************************
