/*******************************************************************************
Project:
                                                                                PENDING

Authors:
  TabareCapitan.com

Description:
  Control
  Treatment
  Extra observations - Control
  Extra observations - Treatment

Requires:
  ssc install savesome

Created: 20180129 | Last modified: 20190929
*******************************************************************************/
version 14.2

clear

*** CONTROL ********************************************************************

forvalues i = 2011(1)2015{

  forvalues j = 10(10)50{

    use "$RUTA\data\temp\raw_`i'_`j'_TR.dta", clear

    run "$RUTA\code\clean.do"

    savesome using "$RUTA\data\temp\raw_`i'_`j'_TRH_extra.dta"                  /// Recover treatment observations
      if timeBlock != 4, replace

    drop if timeBlock != 4

    * Handle Zeros and Missing values (Part 1) ---------------------------------

    forvalues k = 1(1)12{

      replace consumo`k'  = 100000 if consumo`k'  == .
    }

    * Resolve duplicates -------------------------------------------------------

    duplicates drop

    collapse (first) year (first) sucursal (first) timeBlock (firstnm) meter    /// UNRESOLVED: same contract could have different meter
      (sum) consumo1 (sum) consumo2 (sum) consumo3 (sum) consumo4               ///
      (sum) consumo5 (sum) consumo6 (sum) consumo7 (sum) consumo8               ///
      (sum) consumo9 (sum) consumo10 (sum) consumo11 (sum) consumo12            ///
      (firstnm) provincia (firstnm) canton (firstnm) distrito                   ///
      (firstnm) location                                                        /// POTENTIAL ISSUE: same contract with different locations?
      , by(contract)

    * Handle Zeros and Missing values (Part 2) ---------------------------------

    forvalues k = 1(1)12{

      replace consumo`k' = consumo`k' - 300000 if consumo`k' > 300000
      replace consumo`k' = . if consumo`k' == 300000

      replace consumo`k' = consumo`k' - 200000 if consumo`k' > 200000
      replace consumo`k' = . if consumo`k' == 200000

      replace consumo`k' = consumo`k' - 100000 if consumo`k' > 100000
      replace consumo`k' = . if consumo`k' == 100000
    }

    * Reshape data to long -----------------------------------------------------

    sort contract

    reshape long consumo, i(contract) j(month)

    rename consumo consumption

    gen treatment = 0

    gen extra = 0

    save "$RUTA\data\temp\tr_suc_`j'_`i'.dta", replace

  }
}


*** TREATMENT ******************************************************************

forvalues i = 2011(1)2015{

  forvalues j = 10(10)50{

    forvalues k = 8(-1)6{

      use "$RUTA\data\temp\raw_`i'_`j'_TRH.dta", clear

      run "$RUTA\code\clean.do"

      savesome using "$RUTA\data\temp\raw_`i'_`j'_TR_extra.dta"                 /// Recover control observations
        if timeBlock == 4, replace

      drop if timeBlock == 4


      keep if timeBlock == `k'

      * Handle Zeros and Missing values (Part 1) -------------------------------

      forvalues s = 1(1)12{

        replace consumo`s'  = 100000 if consumo`s'  == .                        // To identify missings after collapse
      }

      * Resolve duplicates -----------------------------------------------------

      cap drop status
      duplicates drop

      collapse (first) year (first) sucursal (first) timeBlock                  ///
        (firstnm) meter (sum) consumo1 (sum) consumo2 (sum) consumo3            /// UNRESOLVED: same contract could have different meter
        (sum) consumo4 (sum) consumo5 (sum) consumo6 (sum) consumo7             ///
        (sum) consumo8 (sum) consumo9 (sum) consumo10 (sum) consumo11           ///
        (sum) consumo12 (firstnm) provincia (firstnm) canton                    ///
        (firstnm) distrito (firstnm) location (firstnm) lastRequestDate         /// POTENTIAL ISSUE: same contract with different locations?
        , by(contract)

      * Handle Zeros and Missing values (Part 2) -------------------------------

      forvalues s = 1(1)12{

        replace consumo`s' = consumo`s' - 300000 if consumo`s' > 300000
        replace consumo`s' = . if consumo`s' == 300000

        replace consumo`s' = consumo`s' - 200000 if consumo`s' > 200000
        replace consumo`s' = . if consumo`s' == 200000

        replace consumo`s' = consumo`s' - 100000 if consumo`s' > 100000
        replace consumo`s' = . if consumo`s' == 100000
      }


      * Reshape data to long ---------------------------------------------------

      sort contract

      reshape long consumo, i(contract) j(month)

      rename consumo consumption

      gen treatment = 1

      gen extra = 0

      save "$RUTA\data\temp\trh_`k'_suc_`j'_`i'.dta", replace

    }
  }
}

*** EXTRA CONTROL OBSERVATIONS *************************************************

forvalues i = 2011(1)2015{

  forvalues j = 10(10)50{

    use "$RUTA\data\temp\raw_`i'_`j'_TR_extra.dta", clear

    * Handle Zeros and Missing values (Part 1) ---------------------------------

    forvalues k = 1(1)12{

      replace consumo`k'  = 100000 if consumo`k'  == .
    }

    * Resolve duplicates -------------------------------------------------------

    cap drop status
    cap duplicates drop

    // I use capture collapse to handle no observation cases
    cap collapse (first) year (first) sucursal (first) timeBlock                ///
      (firstnm) meter (sum) consumo1 (sum) consumo2 (sum) consumo3              /// UNRESOLVED: same contract could have different meter
      (sum) consumo4 (sum) consumo5 (sum) consumo6 (sum) consumo7               ///
      (sum) consumo8 (sum) consumo9 (sum) consumo10 (sum) consumo11             ///
      (sum) consumo12  (firstnm) provincia (firstnm) canton                     ///
      (firstnm) distrito (firstnm) location                                     /// POTENTIAL ISSUE: same contract with different locations?                    ///
      , by(contract)

    * Handle Zeros and Missing values (Part 2) ---------------------------------

    forvalues k = 1(1)12{

      replace consumo`k' = consumo`k' - 300000 if consumo`k' > 300000
      replace consumo`k' = . if consumo`k' == 300000

      replace consumo`k' = consumo`k' - 200000 if consumo`k' > 200000
      replace consumo`k' = . if consumo`k' == 200000

      replace consumo`k' = consumo`k' - 100000 if consumo`k' > 100000
      replace consumo`k' = . if consumo`k' == 100000
    }

    * Reshape data to long -----------------------------------------------------

    sort contract

    reshape long consumo, i(contract) j(month)

    rename consumo consumption

    drop if missing(consumption)

    gen treatment = 0

    gen extra = 1

    save "$RUTA\data\temp\raw_`i'_`j'_TR_extraPanel.dta", replace

  }
}


*** EXTRA TREATMENT OBSERVATIONS ***********************************************

forvalues i = 2011(1)2015{

  forvalues j = 10(10)50{

    forvalues k = 8(-1)6{

      use "$RUTA\data\temp\raw_`i'_`j'_TRH_extra.dta", clear

      keep if timeBlock == `k'

      * Handle Zeros and Missing values (Part 1) -------------------------------

      forvalues s = 1(1)12{

        replace consumo`s'  = 100000 if consumo`s'  == .                        // To identify missings after collapse
      }

      * Resolve duplicates -----------------------------------------------------

      cap drop status
      cap duplicates drop

      cap collapse (first) year (first) sucursal (first) timeBlock              ///
        (firstnm) meter (sum) consumo1 (sum) consumo2 (sum) consumo3            /// UNRESOLVED: same contract could have different meter
        (sum) consumo4 (sum) consumo5 (sum) consumo6 (sum) consumo7             ///
        (sum) consumo8 (sum) consumo9 (sum) consumo10 (sum) consumo11           ///
        (sum) consumo12 (firstnm) provincia (firstnm) canton                    ///
        (firstnm) distrito (firstnm) location                                   /// POTENTIAL ISSUE: same contract with different locations?
        , by(contract)

      * Handle Zeros and Missing values (Part 2) -------------------------------

      forvalues s = 1(1)12{

        replace consumo`s' = consumo`s' - 300000 if consumo`s' > 300000
        replace consumo`s' = . if consumo`s' == 300000

        replace consumo`s' = consumo`s' - 200000 if consumo`s' > 200000
        replace consumo`s' = . if consumo`s' == 200000

        replace consumo`s' = consumo`s' - 100000 if consumo`s' > 100000
        replace consumo`s' = . if consumo`s' == 100000
      }


      * Reshape data to long ---------------------------------------------------

      sort contract

      reshape long consumo, i(contract) j(month)

      rename consumo consumption

      drop if missing(consumption)

      gen treatment = 1

      gen extra = 1

      save "$RUTA\data\temp\raw_`i'_`j'_`k'_TRH_extraPanel.dta", replace

    }
  }
}

*** END OF FILE ****************************************************************
********************************************************************************
