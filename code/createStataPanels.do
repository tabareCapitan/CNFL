/*******************************************************************************
Project:     [PENDING]
Author:     tabarecapitan.com

Description:

Requires:

Input:      None
Output:      None

Created: 20180206 | Last modified:  20190929
*******************************************************************************/
version 14

clear

*** BOTH ***********************************************************************

use "$RUTA\data\bothNoOutliers.dta", clear

gen datevar = ym(year,month)

format datevar %tm

xtset contract datevar

save "$RUTA\data\bothNoOutliersXT.dta", replace


*** CONTROL ********************************************************************

use "$RUTA\data\controlNoOutliers.dta", clear

gen datevar = ym(year,month)

format datevar %tm

xtset contract datevar

save "$RUTA\data\controlNoOutliersXT.dta", replace


*** TREATMENT ******************************************************************

use "$RUTA\data\treatmentNoOutliers.dta", clear


gen punta = consumption if timeBlock == 6

gen valle = consumption if timeBlock == 7

gen nocturna = consumption if timeBlock == 8

collapse year sucursal (first) provincia (first) canton (first) distrito        ///
         location contract month treatment (sum) punta (sum) valle (sum)        ///
				 nocturna                                                               ///
        , by(unique)


gen datevar = ym(year,month)

format datevar %tm

xtset contract datevar

save "$RUTA\data\treatmentNoOutliersXT.dta", replace


*** END OF FILE ****************************************************************
********************************************************************************
