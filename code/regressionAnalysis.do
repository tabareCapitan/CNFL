// /*******************************************************************************
// Project: 		[PENDING]
// Author: 		tabarecapitan.com
//
// Description:	Regression analysis
//
// Requires:		ssc install savesome
// 				ssc install reghdfe
// 				ssc install tuples
//
// Created:		20180411
// Last modified:	20180411
// *******************************************************************************/
// version 14
//
// clear
//
//
// *** LOAD ***********************************************************************
//
// use "$RUTA\data\bothNoOutliersXT.dta", clear
//
//
// *** DESCRIPTIVE STATISTICS *****************************************************
//
// bysort treatment: sum consumption
//
//
// *** REGRESSIONS ****************************************************************
//
// *** POOLED ***
//
// reg consumption treatment, vce(cluster contract)
// 	* 4.68 s - treat 184.63 robErr 2.2
//
// reg consumption datevar treatment, vce(cluster contract)
// 	* 4.7 s - treat: 184.384 s robError 2.209
// 	*		- datevar: -.2583
//
// reg consumption i.datevar treatment, vce(cluster contract)
// 	* 51.6 s - treat: 184.3783 robError 2.21
//
// *** FIXED EFFECTS ***
//
// xtreg consumption treatment, fe cluster(contract)
// 	* 66s - treat: 30.23 robErr 5.13
//
// xtreg consumption datevar treatment, fe cluster(contract)
// 	* 76 s - treat: coef 24.23877 robustError 5.129037
// 	*  		 datevar: coef -.2483189 robustError 0.0038814
//
// xtreg consumption i.datevar treatment, fe cluster(contract)	// BEST
// 	* 186s - treat: coef 23.92719 robustError 5.129587
//
// encode(distrito), gen(county)
// xtreg consumption i.datevar treatment county, fe cluster(contract)	// BEST
// 	* s - treat:
//
// reghdfe consumption treatment, a(datevar contract) vce(cluster datevar contract)
// 	* 630 s - treat: coef 23.92719 robustError 5.256914
//
//
// *** PERSISTANCE OF THE EFFECT ***
// /* I don't know how to interpret this regressions
//
// xtreg consumption datevar treatment f.treatment, fe cluster(contract)
//
// xtreg consumption datevar treatment f.treatment f2.treatment f3.treatment 		///
// 	, fe cluster(contract)
// */
//
// *** FIXED EFFECTS BY BLOCK ***
// /*
// drop if location < 1000000000
//
// tostring(location), gen(block)
//
// gen block1 = substr(block, 1, 6)
//
// drop block
//
// destring(block1), gen(block)
//
// drop block1
//
// xtreg consumption i.datevar block treatment, fe cluster(contract)
// 	// block dropped due to collinearity
//
// reghdfe consumption treatment, a(datevar block) vce(cluster datevar contract)
// 	// data is no good to do this (624s)
// */
//
// *** LEFTERS ********************************************************************
//
// use "$RUTA\data\joiners.dta", clear
//
// xtreg consumption datevar treatment, fe cluster(contract)
// 	*  treat: coef 28.86 pvalue 0.058
//
// *** JOINERS ********************************************************************
//
// use "$RUTA\data\lefters.dta", clear
//
// xtreg consumption datevar treatment, fe cluster(contract)
// 	*  treat: coef 18.84 pvalue 0.002
//
// xtreg consumption i.datevar treatment, fe cluster(contract)	// BEST
// 	* treat: coef 17.9 robustError 5.94
//
// *** END OF DOFILE **************************************************************
