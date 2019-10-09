/*******************************************************************************
Project: 		                                                                     [PENDING]
Author: 		tabarecapitan.com

Description:

Requires:

Input:			None
Output:			None

Created:		20180128 | Last modified:	20190929
*******************************************************************************/
version 14.2

clear

*** BOTH ***********************************************************************

use "$RUTA\data\both.dta", clear

drop if consumption < 0
  // 16 obs
drop if consumption == 0
  // 368,447 obs
drop if consumption > 1000
  // 3,441,297 obs

                                                                        // WHATS GOING ON HERE???

save "$RUTA\data\bothNoOutliers.dta", replace


*** CONTROL ********************************************************************
/*
use "$RUTA\data\control.dta", clear

drop if consumption <= 0

* sum consumption, de
// There are almost 3M consumptions > 100000. Check for errors! (still true?)

drop if consumption > 1000

save "$RUTA\data\controlNoOutliers", replace


*** TREATMENT ******************************************************************

use "$RUTA\data\treatment.dta", clear



drop if consumption <= 0

* sum consumption, de
// There are almost 3M consumptions > 100000. Check for errors! (still true?)

drop if consumption > 1000

save "$RUTA\data\treatmentNoOutliers", replace
*/

*** END OF FILE ****************************************************************
********************************************************************************
