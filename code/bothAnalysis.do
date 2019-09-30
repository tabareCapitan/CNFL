// /*******************************************************************************
// Project: 		[PENDING]
// Author: 		tabarecapitan.com
//
// Description:	Analyze control and treatment together
//
// Requires:
//
// Input:			None
// Output:			None
//
// Created:		20180411
// Last modified:	20180411
// *******************************************************************************/
// version 14
//
// clear
//
//
// * 20180829 THE PARALLEL TREND ASSUMPTION
//
// use "$RUTA\data\bothNoOutliersXT.dta", clear
//
//
// //26196 obs
//
// // 12 months - > 8701 observations
// xtreg consumption datevar 														///
// 				  L.treatment  L2.treatment  L3.treatment  L4.treatment			///
// 				  L5.treatment L6.treatment  L7.treatment  L8.treatment 		///
// 				  L9.treatment L10.treatment L11.treatment L12.treatment 		///
// 				  ///
// 				  F.treatment  F2.treatment  F3.treatment  F4.treatment			///
// 				  F5.treatment F6.treatment  F7.treatment  F8.treatment 		///
// 				  F9.treatment F10.treatment F11.treatment F12.treatment, 		///
// 				  ///
// 				  fe cluster(contract)
//
// test 			  L.treatment  L2.treatment  L3.treatment  L4.treatment			///
// 				  L5.treatment L6.treatment  L7.treatment  L8.treatment 		///
// 				  L9.treatment L10.treatment L11.treatment L12.treatment
//
// 				  //Prob > F =    0.7166
//
// test 			  F.treatment  F2.treatment  F3.treatment  F4.treatment			///
// 				  F5.treatment F6.treatment  F7.treatment  F8.treatment 		///
// 				  F9.treatment F10.treatment F11.treatment F12.treatment
//
// 				 // Prob > F =    0.0004
//
// // 6 months - > 15976 observations
// xtreg consumption datevar 													///
// 				  L.treatment  L2.treatment  L3.treatment  L4.treatment			///
// 				  L5.treatment L6.treatment 									///
// 				  ///
// 				  F.treatment  F2.treatment  F3.treatment  F4.treatment			///
// 				  F5.treatment F6.treatment, 									///
// 				  ///
// 				  fe cluster(contract)
//
// test 			  L.treatment  L2.treatment  L3.treatment  L4.treatment			///
// 				  L5.treatment L6.treatment
//
// test 			  F.treatment  F2.treatment  F3.treatment  F4.treatment			///
// 				  F5.treatment F6.treatment
//
// // 3 months - > 15976 observations
// xtreg consumption datevar 													///
// 				  L.treatment  L2.treatment  L3.treatment 						///
// 				  ///
// 				  F.treatment  F2.treatment  F3.treatment,						///
// 				  ///
// 				  fe cluster(contract)
//
// test 			  L.treatment  L2.treatment  L3.treatment
//
// test 			  F.treatment  F2.treatment  F3.treatment
//
//
// *** TIME-SERIES PLOTS **********************************************************
//
// // use "$RUTA\data\bothNoOutliersXT.dta", clear
// //
// // drop if year == 2015 & month > 7
// //
// // gen tConsumption = consumption if treatment == 1
// //
// // gen cConsumption = consumption if treatment == 0
// //
// // collapse tConsumption cConsumption year, by(datevar)
// //
// // twoway (tsline tConsumption) (tsline cConsumption),								///
// // 	ytitle(Consumption (kw)) 													///
// // 	ttitle("") 																	///
// // 	title(Monthly consumption) 													///
// // 	subtitle("")																///
// // 	legend(order(1 "Treatment" 2 "Control") cols(2))	 						///
// // 	scheme(s2mono) 																///
// // 	graphregion(fcolor(white))
// //
// // graph export "$RUTA\figuresTables\tsTreatmentControl.png", replace
//
//
// // *** KERNAL DENSITIES ***********************************************************
// //
// // use "$RUTA\data\bothNoOutliersXT.dta", clear
// //
// // *** ALL THE DATA ***
// //
// // twoway 	(kdensity consumption if treatment) 									///
// // 		(kdensity consumption if !treatment), 									///
// // 		yscale(off) 															///
// // 		xtitle(kW) 																///
// // 		title(Consumption (All the data)) 										///
// // 		note(Epanechnikov kernel densities, position(12)) 						///
// // 		legend(on order(1 "In the program" 2 "Out of the program")) 			///
// // 		scheme(s2mono) 															///
// // 		graphregion(fcolor(white))
// //
// // graph export "$RUTA\figuresTables\kdensityAll.png", replace
// //
// // *** MIXED CONTRACTS ***
// //
// // * Count mixed contracts
// //
// // tab treatment
// //
// // egen tr_mean = mean(treatment), by(contract)
// //
// // preserve
// //
// // 	keep tr_mean contract
// //
// // 	duplicates drop
// //
// // 	count
// //
// // 	isid contract
// //
// // 	count if tr_ == 0		// 	always in contracts
// // 	count if tr_ == 1		//  always out contracts
// // 	count if tr_!=0 & tr!=1	// 680 mixed contracts
// //
// //  restore
// //
// // * drop non-mixed contracts
// //
// // keep if tr_mean!=1 & tr_mean!=0
// //
// // twoway 	(kdensity consumption if treatment) 									///
// // 		(kdensity consumption if !treatment), 									///
// // 		yscale(off) 															///
// // 		xtitle(kW) 																///
// // 		title(Consumption (Program participants)) 								///
// // 		note(Epanechnikov kernel densities, position(12)) 						///
// // 		legend(on order(1 "In the program" 2 "Out of the program") cols(3)) 	///
// // 		scheme(s2mono) 															///
// // 		graphregion(fcolor(white))
// //
// //
// // graph export "$RUTA\figuresTables\kdensityTreated.png", replace
// //
// // *** SEPARATE JOINERS AND LEFTERS ***********************************************
// //
// // *** JOIN THE PROGRAM ***
// //
// // sort contract datevar
// //
// // gen join = 0
// // 	replace join = 1 															///
// // 		if contract[_n] == contract[_n+1] & treatment[_n] < treatment[_n+1]
// //
// // egen joiners = mean(join), by(contract)
// //
// // savesome using "$RUTA\data\joiners.dta" if joiners > 0, replace
// //
// // *** LEFT THE PROGRAM ***
// //
// // gen left = 0
// // 	replace left = 1 															///
// // 		if contract[_n] == contract[_n+1] & treatment[_n] > treatment[_n+1]
// //
// // egen lefters = mean(left), by(contract)
// //
// // savesome using "$RUTA\data\lefters.dta" if lefters > 0, replace
// //
// //
// // * 20180829 THE PARALLEL TREND ASSUMPTION
// //
// // use "$RUTA\data\joiners.dta", clear
// //
// //
// // //2323 obs
// //
// // // 12 months - > 8701 observations
// // xtreg consumption i.datevar 														///
// // 				  L.treatment  L2.treatment  L3.treatment  L4.treatment			///
// // 				  L5.treatment L6.treatment  L7.treatment  L8.treatment 		///
// // 				  L9.treatment L10.treatment L11.treatment L12.treatment 		///
// // 				  ///
// // 				  F.treatment  F2.treatment  F3.treatment  F4.treatment			///
// // 				  F5.treatment F6.treatment  F7.treatment  F8.treatment 		///
// // 				  F9.treatment F10.treatment F11.treatment F12.treatment, 		///
// // 				  ///
// // 				  fe cluster(contract)
// //
// // test 			  L.treatment  L2.treatment  L3.treatment  L4.treatment			///
// // 				  L5.treatment L6.treatment  L7.treatment  L8.treatment 		///
// // 				  L9.treatment L10.treatment L11.treatment L12.treatment
// //
// // test 			  F.treatment  F2.treatment  F3.treatment  F4.treatment			///
// // 				  F5.treatment F6.treatment  F7.treatment  F8.treatment 		///
// // 				  F9.treatment F10.treatment F11.treatment F12.treatment
// //
// // // 6 months - > 3582 observations
// // xtreg consumption i.datevar 													///
// // 				  L.treatment  L2.treatment  L3.treatment  L4.treatment			///
// // 				  L5.treatment L6.treatment 									///
// // 				  ///
// // 				  F.treatment  F2.treatment  F3.treatment  F4.treatment			///
// // 				  F5.treatment F6.treatment, 									///
// // 				  ///
// // 				  fe cluster(contract)
// //
// // test 			  L.treatment  L2.treatment  L3.treatment  L4.treatment			///
// // 				  L5.treatment L6.treatment
// //
// // test 			  F.treatment  F2.treatment  F3.treatment  F4.treatment			///
// // 				  F5.treatment F6.treatment
// //
// // // 3 months - > 4355 observations
// // xtreg consumption i.datevar 													///
// // 				  L.treatment  L2.treatment  L3.treatment 						///
// // 				  ///
// // 				  F.treatment  F2.treatment  F3.treatment,						///
// // 				  ///
// // 				  fe cluster(contract)
// //
// // test 			  L.treatment  L2.treatment  L3.treatment
// //
// // test 			  F.treatment  F2.treatment  F3.treatment
// //
// //
// // *** 20180827: # of joins per month **********************************
// //
// // use "$RUTA\data\joiners.dta", clear
// //
// // gen join2 = join[_n-1] == 1
// //
// // collapse (sum) join2, by(datevar)
// //
// // twoway (tsline join2, recast(bar)),												///
// // 		yscale(on) 																///
// // 		ytitle(Number of contracts)												///
// // 		xtitle("")																///
// // 		title(Contracts joining the program)									///
// // 		scheme(s2mono) 															///
// // 		graphregion(fcolor(white))												///
// // 		xline(0)
// //
// // graph export "$RUTA\figuresTables\numberJoinersPerMonth.png", replace
//
// //
// // *** GRAPH BEFORE-AFTER WITH RELATIVE ENTRANCE **********************************
// //
// // use "$RUTA\data\joiners.dta", clear
// //
// // gen join2 = join[_n-1] == 1
// //
// // replace join = join2
// //
// // drop join2
// //
// // gen startDate = datevar if join == 1
// //
// // egen allStartDate = max(startDate), by(contract)
// //
// // gen relativeEntry = datevar - allStartDate
// //
// // egen meanConsumption = mean(consumption), by(contract)
// //
// // gen demeanedConsumption = consumption - meanConsumption
// //
// // *** GRAPH ***
// //
// // twoway (scatter demeanedConsumption relativeEntry, sort msize (tiny) jitter(2)) ///
// // 	   (lfit demeanedConsumption relativeEntry if relativeEntry < 0) 			///
// // 	   (lfit demeanedConsumption relativeEntry if relativeEntry >= 0),			///
// // 		yscale(off) 															///
// // 		xtitle(Relative entry)													///
// // 		title(Consumption) 														///
// // 		legend(on order(1 "Consumption (Demeaned)" 2 "Fitted line (out)"		///
// // 			3 "Fitted line (in)" ) cols(3))										///
// // 		scheme(s2mono) 															///
// // 		graphregion(fcolor(white))												///
// // 		xline(0)
// //
// // graph export "$RUTA\figuresTables\outInScatter.png", replace
// //
// // * 20180827 NEW GRAPH ***
// //
// // drop if demeanedC > 500 | demeanedC < -500
// //
// // twoway (scatter demeanedConsumption relativeEntry, sort msize (tiny) jitter(2)) ///
// // 	   (lfit demeanedConsumption relativeEntry if relativeEntry < 0) 			///
// // 	   (lfit demeanedConsumption relativeEntry if relativeEntry >= 0),			///
// // 		yscale(off) 															///
// // 		xtitle(Relative entry)													///
// // 		title(Consumption) 														///
// // 		legend(on order(1 "Consumption (Demeaned)" 2 "Fitted line (out)"		///
// // 			3 "Fitted line (in)" ) cols(3))										///
// // 		scheme(s2mono) 															///
// // 		graphregion(fcolor(white))												///
// // 		xline(0)
// //
// // graph export "$RUTA\figuresTables\outInScatter.png", replace
// //
// // *** PLOT # OBS ***
// //
// // count if relativeEntry < 0	// 319
// //
// // count if relativeEntry >= 0	// 4975
// //
// // egen nPeriod = count(year), by(relativeEntry)
// //
// // twoway (spike nPeriod relativeEntry, sort),										///
// // 		title(Number of observations)											///
// // 		ytitle(Number of observations)											///
// // 		scheme(s2mono) 															///
// // 		graphregion(fcolor(white))
// //
// // graph export "$RUTA\figuresTables\outInNPeriods.png", replace
//
// *** 20180827: # of jleft per month **********************************
// //
// // use "$RUTA\data\lefters.dta", clear
// //
// // gen left2 = left[_n-1] == 1
// //
// // collapse (sum) left2, by(datevar)
// //
// // twoway (tsline left2, recast(bar)),												///
// // 		yscale(on) 																///
// // 		ytitle(Number of contracts)												///
// // 		xtitle("")																///
// // 		title(Contracts leaving the program)									///
// // 		scheme(s2mono) 															///
// // 		graphregion(fcolor(white))												///
// // 		xline(0)
// //
// // graph export "$RUTA\figuresTables\numberLeftersPerMonth.png", replace
//
// //
// // *** GRAPH LEFTERS ***
// //
// // use "$RUTA\data\lefters.dta", clear
// //
// // gen left2 = left[_n-1] == 1
// //
// // replace left = left2
// //
// // drop left2
// //
// // gen leftDate = datevar if left == 1
// //
// // egen allLeftDate = max(leftDate), by(contract)
// //
// // gen relativeLeft = datevar - allLeftDate
// //
// // egen meanConsumption = mean(consumption), by(contract)
// //
// // gen demeanedConsumption = consumption - meanConsumption
// //
// // *
// //
// //
// // twoway (scatter demeanedConsumption relativeLeft, sort msize (tiny) ) 			///
// // 	   (lfit demeanedConsumption relativeLeft if relativeLeft < 0)	 			///
// // 	   (lfit demeanedConsumption relativeLeft if relativeLeft >= 0),			///
// // 	    yscale(off) 															///
// // 		xtitle(Relative exit)													///
// // 		title(Consumption) 														///
// // 		legend(on order(1 "Consumption (Demeaned)" 2 "Fitted line (in)"			///
// // 			3 "Fitted line (out)"  cols(3))) 											///
// // 		scheme(s2mono)	 														///
// // 		graphregion(fcolor(white))												///
// // 		xline(0)
// //
// // graph export "$RUTA\figuresTables\inOutScatter.png", replace
// //
// // * 20180827 NEW GRAPH
// //
// // drop if demeanedC > 300 | demeanedC < -300
// //
// // twoway (scatter demeanedConsumption relativeLeft, sort msize (tiny) ) 			///
// // 	   (lfit demeanedConsumption relativeLeft if relativeLeft < 0)	 			///
// // 	   (lfit demeanedConsumption relativeLeft if relativeLeft >= 0),			///
// // 	    yscale(off) 															///
// // 		xtitle(Relative exit)													///
// // 		title(Consumption) 														///
// // 		legend(on order(1 "Consumption (Demeaned)" 2 "Fitted line (in)"			///
// // 			3 "Fitted line (out)"  cols(3))) 											///
// // 		scheme(s2mono)	 														///
// // 		graphregion(fcolor(white))												///
// // 		xline(0)
// //
// //
// // count if relativeLeft < 0	// 11994
// //
// // count if relativeLeft >= 0	// 14202
// //
// // *
// //
// // egen nPeriod = count(year), by(relativeLeft)
// //
// // twoway (spike nPeriod relativeLeft, sort),										///
// // 		title(Number of observations)											///
// // 		ytitle(Number of observations)											///
// // 		scheme(s2mono) 															///
// // 		graphregion(fcolor(white))
// //
// // graph export "$RUTA\figuresTables\inOutNPeriods.png", replace
//
// // * 20180829 THE PARALLEL TREND ASSUMPTION (LEFT)*********************************
// //
// // use "$RUTA\data\lefters.dta", clear
// //
// // gen left2 = left[_n-1] == 1
// //
// // rename left2  first
// //
// // gen l = L.first
// // gen l2 = L2.first	// L is after
// //
// // gen f = F.first
// // gen f2 = F2.first	// F is before
// //
// //
// // //26196 obs
// //
// // *** 12 MONTHS *** - > 8701 observations
// //
// // xtreg consumption i.datevar F12.first  F11.first  F10.first  F9.first			///
// // 							F8.first   F7.first   F6.first   F5.first 			///
// // 							F4.first   F3.first   F2.first   F.first 			///
// // 							///
// // 							L.first  L2.first  L3.first  L4.first				///
// // 							L5.first L6.first  L7.first  L8.first 				///
// // 							L9.first L10.first L11.first L12.first, 			///
// // 							///
// // 							fe cluster(contract)
// //
// //
// // test F.first  F2.first F3.first F4.first  F5.first  F6.first 					///
// // 	 F7.first F8.first F9.first F10.first F11.first F12.first
// //
// // 	 // pvalue = 0.002 -> Reject jointly = 0
// //
// // test L.first   L2.first  L3.first L4.first  L5.first  L6.first  				///
// //      L7.first  L8.first	 L9.first L10.first L11.first L12.first
// //
// // 	// pvalue = 0.4428 -> Do not reject jointly = 0
// //
// // * GRAPH
// // xtreg consumption i.datevar F12.first  F11.first  F10.first  F9.first			///
// // 							F8.first   F7.first   F6.first   F5.first 			///
// // 							F4.first   F3.first   F2.first   F.first 			///
// // 							first 												///
// // 							L.first  L2.first  L3.first  L4.first				///
// // 							L5.first L6.first  L7.first  L8.first 				///
// // 							L9.first L10.first L11.first L12.first, 			///
// // 							///
// // 							fe cluster(contract)
// //
// // coefplot, keep(F* first  L*)  yline(0) msymbol(d) mcolor(white)					///
// // 		  levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1)) 		///
// // 		  legend(order(1 "99" 2 "95" 3 "90" ) row(1)) vertical					///
// // 		  scheme(s2mono) 	///													///
// // 	      graphregion(fcolor(white)) 											///
// // 		  title("Effect of the program over time")								///
// // 		  subtitle("Point estimates and different confidence intervals")		///
// // 		  xtitle(Time relative to exit of the program) ytitle(kwh)				///
// // 		  xlabel(1 "-12" 4 "-9" 7 "-6" 10 "-3" 13 "Exit" 16 "3" 19 "6" 22 "9" 	///
// // 		  25 "12", labsize(small) )
// //
// // 		  graph export "$RUTA\figuresTables\overtime12left.png", replace
// //
// //
// //
// // *** 6 MONTHS *** - > 15976 observations
// //
// // xtreg consumption i.datevar F6.first   F5.first F4.first   						///
// // 							F3.first   F2.first F.first 						///
// // 							///
// // 							L.first  L2.first L3.first  						///
// // 							L4.first L5.first L6.first,  						///
// // 							///
// // 							fe cluster(contract)
// //
// //
// // test F.first  F2.first F3.first F4.first  F5.first  F6.first
// //
// // 	// pvalue = 0	-> reject jointly = 0
// //
// // test L.first   L2.first  L3.first L4.first  L5.first  L6.first
// //
// // 	// pvalue = 0.1205
// //
// //
// // * GRAPH
// // xtreg consumption i.datevar F6.first   F5.first F4.first   						///
// // 							F3.first   F2.first F.first 						///
// // 							first ///
// // 							L.first  L2.first L3.first  						///
// // 							L4.first L5.first L6.first,  						///
// // 							///
// // 							fe cluster(contract)
// //
// // coefplot, keep(F* first  L*)  yline(0) msymbol(d) mcolor(white)					///
// // 		  levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1)) 		///
// // 		  legend(order(1 "99" 2 "95" 3 "90" ) row(1)) vertical					///
// // 		  scheme(s2mono) 	///													///
// // 	      graphregion(fcolor(white)) 											///
// // 		  title("Effect of the program over time")								///
// // 		  subtitle("Point estimates and different confidence intervals")		///
// // 		  xtitle(Time relative to exit of the program) ytitle(kwh)				///
// // 		  xlabel(1 "-6" 4 "-3" 7 "Exit" 10 "3" 13 "6", labsize(small) )
// //
// // 		  graph export "$RUTA\figuresTables\overtime6left.png", replace
// //
// // *** 3 MONTHS *** - > 15976 observations
// //
// // xtreg consumption i.datevar	F3.first   F2.first F.first 						///
// // 							///
// // 							L.first  L2.first L3.first,							///
// // 							///
// // 							fe cluster(contract)
// //
// //
// // test F.first  F2.first F3.first
// //
// // 	// pvalue = 0	-> reject jointly = 0
// //
// // test L.first   L2.first  L3.first
// //
// // 	// pvalue = 0.24
// //
// //
// // * GRAPH
// // xtreg consumption i.datevar	F3.first   F2.first F.first 						///
// // 							first ///
// // 							L.first  L2.first L3.first,  						///
// // 							///
// // 							fe cluster(contract)
// //
// // coefplot, keep(F* first  L*)  yline(0) msymbol(d) mcolor(white)					///
// // 		  levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1)) 		///
// // 		  legend(order(1 "99" 2 "95" 3 "90" ) row(1)) vertical					///
// // 		  scheme(s2mono) 	///													///
// // 	      graphregion(fcolor(white)) 											///
// // 		  title("Effect of the program over time")								///
// // 		  subtitle("Point estimates and different confidence intervals")		///
// // 		  xtitle(Time relative to exit of the program) ytitle(kwh)				///
// // 		  xlabel(1 "-3" 4 "Exit" 7 "3", labsize(small) )
// //
// // 		  graph export "$RUTA\figuresTables\overtime3left.png", replace
//
// * 20180829 THE PARALLEL TREND ASSUMPTION ***************************************
// //
// // use "$RUTA\data\joiners.dta", clear
// //
// // gen join2 = join[_n-1] == 1
// //
// // rename join2 first
// //
// //
// // gen f = F.first		// before
// //
// // gen f2 = F2.first
// //
// // gen l = L.first		// after
// //
// // gen l2 = L2.first
// //
// //
// // *** 6 MONTHS *** - > 3582 observations
// //
// // xtreg consumption i.datevar F6.first   F5.first F4.first   						///
// // 							F3.first   F2.first F.first 						///
// // 							///
// // 							L.first  L2.first L3.first  						///
// // 							L4.first L5.first L6.first,  						///
// // 							///
// // 							fe cluster(contract)
// //
// //
// // test F.first  F2.first F3.first F4.first  F5.first  F6.first
// //
// // 		// pvalue = 0
// //
// // test L.first   L2.first  L3.first L4.first  L5.first  L6.first
// //
// // 		// pvalue = .4998
// //
// // * GRAPH
// // xtreg consumption i.datevar F6.first   F5.first F4.first   						///
// // 							F3.first   F2.first F.first 						///
// // 							first ///
// // 							L.first  L2.first L3.first  						///
// // 							L4.first L5.first L6.first,  						///
// // 							///
// // 							fe cluster(contract)
// //
// // coefplot, keep(F* first  L*)  yline(0) msymbol(d) mcolor(white)					///
// // 		  levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1)) 		///
// // 		  legend(order(1 "99" 2 "95" 3 "90" ) row(1)) vertical					///
// // 		  scheme(s2mono) 	///													///
// // 	      graphregion(fcolor(white)) 											///
// // 		  title("Effect of the program over time")								///
// // 		  subtitle("Point estimates and different confidence intervals")		///
// // 		  xtitle(Time relative to joining the program) ytitle(kwh)				///
// // 		  xlabel(1 "-6" 4 "-3" 7 "Join" 10 "3" 13 "6", labsize(small) )
// //
// // 		  graph export "$RUTA\figuresTables\overtime6join.png", replace
// //
//
// //
// // *** 3 MONTHS *** - > 4255 observations
// //
// // xtreg consumption i.datevar F3.first   F2.first F.first 						///
// // 							///
// // 							L.first  L2.first L3.first,  						///
// // 							///
// // 							fe cluster(contract)
// //
// //
// // test F.first  F2.first F3.first
// // 		// pvalue = 0.076
// //
// // test L.first   L2.first  L3.first
// //
// // 		// pvalue = .60
// //
// // * GRAPH
// // xtreg consumption i.datevar F3.first   F2.first F.first 						///
// // 							first ///
// // 							L.first  L2.first L3.first,  						///
// // 							///
// // 							fe cluster(contract)
// //
// // coefplot, keep(F* first  L*) yline(0) msymbol(d) mcolor(white)					///
// // 		  levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1)) 		///
// // 		  legend(order(1 "99" 2 "95" 3 "90" ) row(1)) vertical					///
// // 		  scheme(s2mono) 	///													///
// // 	      graphregion(fcolor(white)) 											///
// // 		  title("Effect of the program over time")								///
// // 		  subtitle("Point estimates and different confidence intervals")		///
// // 		  xtitle(Time relative to joining the program) ytitle(kwh)				///
// // 		  xlabel(1 "-3" 4 "Join" 7 "3" , labsize(small) )
// //
// // 		  graph export "$RUTA\figuresTables\overtime3join.png", replace
//
//
//
//
// *** END OF FILE ****************************************************************
// ********************************************************************************
