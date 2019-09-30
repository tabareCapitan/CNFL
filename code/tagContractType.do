/*******************************************************************************
Project:
                                                                                PENDING

Authors:
TabareCapitan.com

Description:


Created: 20190929 | Last modified: 20190929
*******************************************************************************/
version 14.2


*** LOAD DATA ******************************************************************

use "$RUTA\data\bothNoOutliersXT.dta", clear

egen tr_mean = mean(treatment), by(contract)


*** TAG CONTRACTS JOINING THE PROGRAM ******************************************

sort contract datevar

gen join = 0 if tr_mean > 0 & tr_mean < 1

	replace join = 1 															                                ///
		if contract[_n] == contract[_n+1] & treatment[_n] < treatment[_n+1]

egen joiners = mean(join), by(contract)


*** TAG CONTRACTS LEAVING THE PROGRAM ******************************************

gen left = 0 if tr_mean > 0 & tr_mean < 1
	replace left = 1 														                                	///
		if contract[_n] == contract[_n+1] & treatment[_n] > treatment[_n+1]

egen lefters = mean(left), by(contract)

*** TAG CONTRACTS ENTERING AND LEAVING THE PROGRAM *****************************

gen tag = lefters > 0 & !missing(lefters) & joiners > 0 & !missing(joiners)

drop if tag == 1

drop tag

*** CONTRACT TYPE **************************************************************

gen contractType = .

  replace contractType = 0 if tr_mean == 0
  replace contractType = 1 if tr_mean == 1
  replace contractType = 2 if joiners > 0 & !missing(joiners)
  replace contractType = 3 if lefters > 0 & !missing(lefters)

*** SAVE ***********************************************************************

save "$RUTA\data\bothNoOutliersXTNewType.dta", replace


*** END OF FILE ****************************************************************
********************************************************************************
