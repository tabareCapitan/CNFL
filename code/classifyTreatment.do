/*******************************************************************************
Project: 		[PENDING]
Author: 		tabarecapitan.com

Description:	Classify contracts in treatment in 3 groups:
					- Always treated
					- Joined
					- Left

Requires:		ssc install savesome

Created:		20180411
Last modified:	20180411
*******************************************************************************/
version 14.2

clear


*** DROP ALWAYS TREATED AND ALWAYS CONTROL *************************************

use "$RUTA\data\bothNoOutliersXT.dta", clear

tab treatment

egen tr_mean = mean(treatment), by(contract)

keep if tr_mean!=1 & tr_mean!=0


*** SAVE CONTRATS "JOIN" *******************************************************

sort contract datevar

gen join = 0
	replace join = 1 															///
		if contract[_n] == contract[_n+1] & treatment[_n] < treatment[_n+1]

egen joiners = mean(join), by(contract)

savesome using "$RUTA\data\joiners.dta" if joiners > 0, replace


*** SAVE CONTRATS "LEFT" *******************************************************

gen left = 0
	replace left = 1 															///
		if contract[_n] == contract[_n+1] & treatment[_n] > treatment[_n+1]

egen lefters = mean(left), by(contract)

savesome using "$RUTA\data\lefters.dta" if lefters > 0, replace


*** TAG JOIN AND LEFT CONTRACTS ************************************************

use "$RUTA\data\treatmentNoOutliersXT.dta", clear

*** JOINERS ***

merge 1:1 unique using "$RUTA\data\joiners.dta"

gen treatmentType = 1 if _merge == 3

drop if _merge == 2

drop _merge joiners join tr_mean consumption


*** LEFTERS ***

merge 1:1 unique using "$RUTA\data\lefters.dta"

replace treatmentType = -1 if _merge == 3

drop if _merge == 2

drop _merge left lefters join joiners tr_mean consumption

*** ALWAYS IN THE TREATMENT

replace treatmentType = 0 if missing(treatmentType)

*** SAVE ***********************************************************************

save "$RUTA\data\treatmentNoOutliersXTtype.dta", replace


*** END OF DO FILE *************************************************************
********************************************************************************
