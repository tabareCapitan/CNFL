/*******************************************************************************
Project:
                                                                                PENDING

Authors:
TabareCapitan.com

Description:


Created: 20180128 | Last modified: 20190804
*******************************************************************************/
version 14.2

clear

********************************************************************************

forvalues i = 2011(1)2015{

	forvalues j = 10(10)50{

		di "Current dataset: " `i' " " `j'

		#delimit ;

		// CONTROL ;

		import excel using
							"$RUTA\data\raw\TR por sucursal\Suc.`j' Servs TR Consumos `i'",
							clear first case(lower) ;

		gen sucursal = `j';

		save "$RUTA\data\temp\raw_`i'_`j'_TR.dta", replace;


		// TREATMENT

		import excel using
						"$RUTA\data\raw\TRH por sucursal\Suc.`j' Servs TRH Consumos `i'",
						clear first case(lower) ;

		gen sucursal = `j';

		save "$RUTA\data\temp\raw_`i'_`j'_TRH.dta", replace;

		#delimit cr

	}
}

*** END OF FILE ****************************************************************
********************************************************************************
