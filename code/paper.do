/*******************************************************************************
Project:
                                                                                PENDING

Authors:
TabareCapitan.com

Description:


Created: 20190929 | Last modified: 20190929
*******************************************************************************/
version 14.2


*** NUMBER OF CONTRACTS BY TYPE ************************************************ TABLE 2

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

gcollapse contractType, by(contract)

tab contractType, mi


*** MEAN CONSUMPTION FOR EACH TYPE IN AND OUT ********************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

* GET MEANS --------------------------------------------------------------------

gen position = .

forvalues i = 1(1)11{

  replace position = `i' in `i'
}


gen means = .

* ALWAYS OUT

sum consumption if contractType == 0 & treatment == 0

local mean2 = string(r(mean),"%04.2f")

local mean2pos = r(mean) + 0.02

replace means = r(mean) in 2

* ALWAYS IN

sum consumption if contractType == 1 & treatment == 1

local mean4 = string(r(mean),"%04.2f")

local mean4pos = r(mean) + 0.02

replace means = r(mean) in 4

* JOIN: OUT

sum consumption if contractType == 2 & treatment == 0

local mean6 = string(r(mean),"%04.2f")

local mean6pos = r(mean) + 0.02

replace means = r(mean) in 6

* JOIN: IN

sum consumption if contractType == 2 & treatment == 1

local mean7 = string(r(mean),"%04.2f")

local mean7pos = r(mean) + 0.02

replace means = r(mean) in 7

* LEFT: OUT

sum consumption if contractType == 3 & treatment == 0

local mean9 = string(r(mean),"%04.2f")

local mean9pos = r(mean) + 0.02

replace means = r(mean) in 9

* LEFT: IN

sum consumption if contractType == 3 & treatment == 1

local mean10 = string(r(mean),"%04.2f")

local mean10pos = r(mean) + 0.02

replace means = r(mean) in 10

* GRAPH ------------------------------------------------------------------------

#delimit ;

twoway  (bar means position if position == 2  ,
                   color(black) lcolor(black) lwidth(medium) )
        (bar means position if position == 4  ,
                   color(none)  lcolor(black) lwidth(medium) )
        (bar means position if position == 6  ,
                   color(black)  lcolor(black) lwidth(medium))
        (bar means position if position == 7  ,
                   color(none) lcolor(black) lwidth(medium) )
        (bar means position if position == 9  ,
                   color(black)  lcolor(black) lwidth(medium) )
        (bar means position if position == 10  ,
                   color(none)  lcolor(black) lwidth(medium))
        ,
        title("")
        subtitle("")

        ytitle("Consumption (kWh)")
        ylabel(0(50)500, ang(h))

        xtitle("")
        xlabel(1 " " 2 "Always out" 4 "Always in" 6.5 "Join" 9.5 "Left" 11 " ")

        legend( order(1 "Out" 2 "In") ring(0) pos(11) cols(1)
                                                      region(lcolor(none)) )

        text(`mean2pos' 1.55 "`mean2'",
          placement("ne") orientation("horizontal") size("medsmall")
          color("black")
        )
        text(`mean4pos' 3.55 "`mean4'",
          placement("ne") orientation("horizontal") size("medsmall")
          color("black")
        )
        text(`mean6pos' 5.55 "`mean6'",
          placement("ne") orientation("horizontal") size("medsmall")
          color("black")
        )
        text(`mean7pos' 6.55 "`mean7'",
          placement("ne") orientation("horizontal") size("medsmall")
          color("black")
        )
        text(`mean9pos' 8.55 "`mean9'",
          placement("ne") orientation("horizontal") size("medsmall")
          color("black")
        )
        text(`mean10pos' 9.55 "`mean10'",
          placement("ne") orientation("horizontal") size("medsmall")
          color("black")
        )
        ;

graph export "$RUTA\figures\meansByContractType.png", replace
                                                    width(10000) height(8000);

#delimit cr

*** TIME-SERIES PLOTS ********************************************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

drop if year == 2015 & month > 7

gen tConsumption = consumption if treatment == 1

gen cConsumption = consumption if treatment == 0

gcollapse tConsumption cConsumption year, by(datevar)

#delimit ;

twoway (tsline cConsumption, lpattern(dash)) (tsline tConsumption) ,
    ytitle(Consumption (kw))
    ttitle("")
    title("")
    subtitle("")
    legend(off)
    text(248 657 "Block pricing",
      placement("ne") orientation("horizontal") size("medsmall")
      color("black")
    )
    text(435 652 "Time-variant pricing",
      placement("ne") orientation("horizontal") size("medsmall")
      color("black")
    )
    ;

graph export "$RUTA\figures\timeSeriesPlot.png", replace
                                                  width(10000) height(6000);

#delimit cr

*** KERNAL DENSITIES *********************************************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

* ALL CONTRACTS ----------------------------------------------------------------

#delimit ;

twoway  (kdensity consumption if treatment)
        (kdensity consumption if !treatment, lpattern(dash)),
        yscale(off)
        xtitle(kWh)
        title("All households")
        legend(on order(1 "Time-variant pricing" 2 "Block pricing")
                            ring(0) pos(1) cols(1) region(lcolor(none)))
        saving("$RUTA\figures\temp\kernelAll", replace)
        ;

graph export "$RUTA\figures\kdensityAll.png", replace
                                                width(10000) height(8000);

* ONLY CONTRACTS ON THE PROGRAM AT LEAST ONE MONTH -----------------------------

drop if contractType == 0;

twoway  (kdensity consumption if treatment)
        (kdensity consumption if !treatment, lpattern(dash)),
        yscale(off)
        xtitle(kWh)
        title("All HH in the program")
        legend(on order(1 "Time-variant pricing" 2 "Block pricing")
                            ring(0) pos(1) cols(1) region(lcolor(none)))
        saving("$RUTA\figures\temp\kernelAllTVP", replace)
        ;

graph export "$RUTA\figures\kdensityTVPcontracts.png", replace
                                                width(10000) height(8000);

* ONLY CONTRACTS THAT JOINED ---------------------------------------------------

twoway  (kdensity consumption if  treatment & contractType == 2)
        (kdensity consumption if !treatment & contractType == 2,
                                                              lpattern(dash)),
        yscale(off)
        xtitle(kWh)
        title("HH that joined")
        legend(on order(1 "Time-variant pricing" 2 "Block pricing")
                            ring(0) pos(1) cols(1) region(lcolor(none)))
        saving("$RUTA\figures\temp\kernelJoin", replace)
        ;

graph export "$RUTA\figures\kdensityTVPcontractsJoin.png", replace
                                              width(10000) height(8000);


* ONLY CONTRACTS THAT LEFT -----------------------------------------------------

twoway  (kdensity consumption if  treatment & contractType == 3)
        (kdensity consumption if !treatment & contractType == 3,
                                                              lpattern(dash)),
        yscale(off)
        xtitle(kWh)
        title("HH that left")
        legend(on order(1 "Time-variant pricing" 2 "Block pricing")
                            ring(0) pos(1) cols(1) region(lcolor(none)))
        saving("$RUTA\figures\temp\kernelLeft", replace)
        ;

graph export "$RUTA\figures\kdensityTVPcontractsLeft.png", replace
                                              width(10000) height(8000);


*** COMBINE ********************************************************************

grc1leg       "$RUTA\figures\temp\kernelAll"
              "$RUTA\figures\temp\kernelAllTVP"
              "$RUTA\figures\temp\kernelJoin"
              "$RUTA\figures\temp\kernelLeft"
              ,
              rows(2);


graph export "$RUTA\figures\kdensity4Cases.png", replace
                                                  width(16000) height(12000);


#delimit cr


*** # OF CONTRACTS JOINING EACH MONTH ****************************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

keep if contractType == 2

gen join2 = join[_n-1] == 1

collapse (sum) join2, by(datevar)

#delimit ;

twoway  (tsline join2, recast(bar)),
    		yscale(on)
        ylabel(,ang(h))
    		ytitle(Number of contracts)
    		xtitle("")
    		title("")
    		xline(0)
        ;

graph export "$RUTA\figures\numberJoinersPerMonth.png", replace
                                                    width(10000) height(8000);

#delimit cr

*** # OF CONTRACTS LEAVING EACH MONTH ****************************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

keep if contractType == 3

gen left2 = left[_n-1] == 1

collapse (sum) left2, by(datevar)

#delimit ;

twoway  (tsline left2, recast(bar)),
    		yscale(on)
        ylabel(,ang(h))
    		ytitle(Number of contracts)
    		xtitle("")
    		title("")
    		xline(0)
        ;

graph export "$RUTA\figuresTables\numberLeftersPerMonth.png", replace
                                                  width(10000) height(8000);

#delimit cr


*** GRAPH BEFORE-AFTER WITH RELATIVE ENTRANCE ********************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

* PREPARE ----------------------------------------------------------------------

keep if contractType == 2

gen join2 = join[_n-1] == 1

replace join = join2

drop join2

gen startDate = datevar if join == 1

egen allStartDate = max(startDate), by(contract)

gen relativeEntry = datevar - allStartDate

egen meanConsumption = mean(consumption), by(contract)

gen demeanedConsumption = consumption - meanConsumption

drop if demeanedC > 500 | demeanedC < -500

* GRAPH ------------------------------------------------------------------------

#delimit ;

twoway (scatter demeanedConsumption relativeEntry, sort msize (tiny) jitter(2))
  	   (lfit demeanedConsumption relativeEntry if relativeEntry < 0)
  	   (lfit demeanedConsumption relativeEntry if relativeEntry >= 0)
       ,
    	 yscale(off)
    	 xtitle(Relative entry)
    	 title("")
    	 legend(on order(1 "Consumption (Demeaned)" 2 "Fitted line (out)"
    	 3 "Fitted line (in)" ) cols(3))
    	 xline(0)
       ;

graph export "$RUTA\figures\outInScatter.png", replace
                                                    width(10000) height(8000);

#delimit cr

*** JOIN: PLOT # OBS IN EACH MONTH  ******************************************** FIGURE X

count if relativeEntry < 0	// 256

count if relativeEntry >= 0	// 4294

egen nPeriod = count(year), by(relativeEntry)

#delimit ;

twoway  (spike nPeriod relativeEntry, sort),
    		title("")
        ylabel(,ang(h))
    		ytitle(Number of observations)
        ;

graph export "$RUTA\figures\outInNPeriods.png", replace
                                                  width(10000) height(8000);


#delimit cr

*** GRAPH AFTER-BEFORE WITH RELATIVE EXIT ********************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

keep if contractType == 3

* PREPARE ----------------------------------------------------------------------

gen left2 = left[_n-1] == 1

replace left = left2

drop left2

gen leftDate = datevar if left == 1

egen allLeftDate = max(leftDate), by(contract)

gen relativeLeft = datevar - allLeftDate

egen meanConsumption = mean(consumption), by(contract)

gen demeanedConsumption = consumption - meanConsumption

drop if demeanedC > 300 | demeanedC < -300

* GRAPH ------------------------------------------------------------------------

#delimit ;

------------------------!!!! VOY POR ACA!!!!!!!!!!!!!!!!

twoway (scatter demeanedConsumption relativeLeft, sort msize (tiny) )
	     (lfit demeanedConsumption relativeLeft if relativeLeft < 0)
	     (lfit demeanedConsumption relativeLeft if relativeLeft >= 0),
	     yscale(off)
		   xtitle(Relative exit)
		   title("")
		   legend(on order(1 "Consumption (Demeaned)" 2 "Fitted line (in)"
			                                     3 "Fitted line (out)"  cols(3)))
		   xline(0)
;

graph export "$RUTA\figuresTables\inOutScatter.png", replace


*** LEFT: PLOT # OBS IN EACH MONTH  ******************************************** FIGURE X

count if relativeLeft < 0	// 11994

count if relativeLeft >= 0	// 14202

*

egen nPeriod = count(year), by(relativeLeft)

twoway (spike nPeriod relativeLeft, sort),										///
		title(Number of observations)											///
		ytitle(Number of observations)											///
		scheme(s2mono) 															///
		graphregion(fcolor(white))

graph export "$RUTA\figuresTables\inOutNPeriods.png", replace
*** XXXX *********************************************************




  width(10000) height(8000);


*** END OF FILE ****************************************************************
********************************************************************************
  width(10000) height(8000);
