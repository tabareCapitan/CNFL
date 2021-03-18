/*******************************************************************************
Project:
                                                                                PENDING

Authors:
TabareCapitan.com

Description:


Created: 20190929 | Last modified: 20191009
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

local mean2pos = r(mean) + 0.03

replace means = r(mean) in 2

* ALWAYS IN

sum consumption if contractType == 1 & treatment == 1

local mean4 = string(r(mean),"%04.2f")

local mean4pos = r(mean) + 0.03

replace means = r(mean) in 4

* JOIN: OUT

sum consumption if contractType == 2 & treatment == 0

local mean6 = string(r(mean),"%04.2f")

local mean6pos = r(mean) + 0.03

replace means = r(mean) in 6

* JOIN: IN

sum consumption if contractType == 2 & treatment == 1

local mean7 = string(r(mean),"%04.2f")

local mean7pos = r(mean) + 0.03

replace means = r(mean) in 7

* LEFT: OUT

sum consumption if contractType == 3 & treatment == 0

local mean9 = string(r(mean),"%04.2f")

local mean9pos = r(mean) + 0.03

replace means = r(mean) in 9

* LEFT: IN

sum consumption if contractType == 3 & treatment == 1

local mean10 = string(r(mean),"%04.2f")

local mean10pos = r(mean) + 0.03

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

        ytitle("Consumption (kW h)")
        ylabel(0(50)500, ang(h))

        xtitle("")
        xlabel(1 " " 2 "Group O" 4 "Group I" 6.5 "Group J" 9.5 "Group L" 11 " ")

        legend( order(1 "Out" 2 "In") ring(0) pos(11) cols(1)
                                                      region(lcolor(none)) )

        text(`mean2pos' 1.55 "`mean2'",
          placement("ne") orientation("horizontal") size("small")
          color("black")
        )
        text(`mean4pos' 3.55 "`mean4'",
          placement("ne") orientation("horizontal") size("small")
          color("black")
        )
        text(`mean6pos' 5.55 "`mean6'",
          placement("ne") orientation("horizontal") size("small")
          color("black")
        )
        text(`mean7pos' 6.55 "`mean7'",
          placement("ne") orientation("horizontal") size("small")
          color("black")
        )
        text(`mean9pos' 8.55 "`mean9'",
          placement("ne") orientation("horizontal") size("small")
          color("black")
        )
        text(`mean10pos' 9.55 "`mean10'",
          placement("ne") orientation("horizontal") size("small")
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
    ytitle(Consumption (kW h))
    ttitle("")
    title("")
    subtitle("")
    legend(off)
    text(248 657 "Block pricing",
      placement("ne") orientation("horizontal") size("small")
      color("black")
    )
    text(435 652 "Time-variant pricing",
      placement("ne") orientation("horizontal") size("small")
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

twoway  (kdensity consumption if treatment, lcolor(red))
        (kdensity consumption if !treatment, lcolor(blue) lpattern(dash)),
        yscale(off)
        xtitle(kW h)
        title("Groups O, I, J, L")
        legend(on order(1 "Time-varying pricing" 2 "Block pricing")
                            ring(0) pos(1) cols(1) region(lcolor(none)))
        saving("$RUTA\figures\temp\kernelAll", replace)
        ;

* ONLY CONTRACTS ON THE PROGRAM AT LEAST ONE MONTH ----------------------------;

drop if contractType == 0;

twoway  (kdensity consumption if treatment, lcolor(red))
        (kdensity consumption if !treatment, lcolor(blue) lpattern(dash)),
        yscale(off)
        xtitle(kW h)
        title("Groups I, J, L")
        legend(on order(1 "Time-varying pricing" 2 "Block pricing")
                            ring(0) pos(1) cols(1) region(lcolor(none)))
        saving("$RUTA\figures\temp\kernelAllTVP", replace)
        ;

* ONLY CONTRACTS THAT JOINED --------------------------------------------------;

twoway  (kdensity consumption if  treatment & contractType == 2, lcolor(red))
        (kdensity consumption if !treatment & contractType == 2,
                                                lcolor(blue)  lpattern(dash)),
        yscale(off)
        xtitle(kW h)
        title("Group J")
        legend(on order(1 "Time-varying pricing" 2 "Block pricing")
                            ring(0) pos(1) cols(1) region(lcolor(none)))
        saving("$RUTA\figures\temp\kernelJoin", replace)
        ;

* ONLY CONTRACTS THAT LEFT ----------------------------------------------------;

twoway  (kdensity consumption if  treatment & contractType == 3, lcolor(red))
        (kdensity consumption if !treatment & contractType == 3,
                                                lcolor(blue)   lpattern(dash)),
        yscale(off)
        xtitle(kW h)
        title("Group L")
        legend(on order(1 "Time-varying pricing" 2 "Block pricing")
                            ring(0) pos(1) cols(2) region(lcolor(none)))
        saving("$RUTA\figures\temp\kernelLeft", replace)
        ;

*** COMBINE -------------------------------------------------------------------;

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

twoway  (tsline join2, recast(bar) fcolor(gs10)),
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

twoway  (tsline left2, recast(bar) fcolor(gs10)),
        yscale(on)
        ylabel(,ang(h))
        ytitle(Number of contracts)
        xtitle("")
        title("")
        xline(0)
        ;

graph export "$RUTA\figures\numberLeftersPerMonth.png", replace
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

twoway (scatter demeanedConsumption relativeEntry, sort msize (tiny) jitter(2)
                                                                fcolor(black))
       (lfit demeanedConsumption relativeEntry if relativeEntry < 0,
                                                                lcolor(red))
       (lfit demeanedConsumption relativeEntry if relativeEntry >= 0,
                                                                lcolor(red))
       ,
       yscale(on)
       ytitle("Demeaned consumption (kW h)")
       xtitle("Relative periods (0 = Join TVP)")
       title("")
       legend(off order(1 "Consumption (Demeaned)" 2 "Fitted line (out)"
       3 "Fitted line (in)" ) cols(3))
       xline(0)
       ;

graph export "$RUTA\figures\outInScatter.png", replace
                                                    width(10000) height(8000);

#delimit cr

*** CONSUMPTION PATTERNS AFTER JOINING *****************************************

keep if treatment == 1

collapse demeanedConsumption, by(relativeEntry)

#delimit ;

twoway  (line demeanedConsumption relativeEntry, lpattern(solid)),
          ytitle("Demeaned consumption (kW h)")
          ttitle("Relative periods (0 = Join TVP)")
          yline(0, lpattern(dash))
          title("")
          ;

graph export "$RUTA\figures\consumptionAfterEntry.png", replace
                                            width(10000) height(8000);

#delimit cr

*** JOIN: PLOT # OBS IN EACH MONTH  ******************************************** FIGURE X

// need to reload data because of the collapse above

count if relativeEntry < 0  // 256

count if relativeEntry >= 0  // 4294

egen nPeriod = count(year), by(relativeEntry)

#delimit ;

twoway  (spike nPeriod relativeEntry, sort),
        title("")
        ylabel(,ang(h))
        ytitle("Number of observations")
        xtitle("Relative entry (0 = Join TVP)")
        ;

graph export "$RUTA\figures\outInNPeriods.png", replace
                                                  width(10000) height(8000);


#delimit cr



*** ALWAYS TREATED: PLOT # OBS IN EACH MONTH  ********************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

* PREPARE ----------------------------------------------------------------------

keep if contractType == 1

egen nPeriod = count(year), by(datevar)

#delimit ;

twoway  (spike nPeriod datevar, sort),
        title("")
        ylabel(,ang(h))
        ytitle("Number of observations")
        xtitle("Date")
        ;

graph export "$RUTA\figures\inObs.png", replace
                                                  width(10000) height(8000);


#delimit cr

*** GRAPH AFTER-BEFORE WITH RELATIVE EXIT ************************************** FIGURE X

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

twoway (scatter demeanedConsumption relativeLeft, sort msize (tiny)  jitter(2)
                                                                fcolor(black))
       (lfit demeanedConsumption relativeLeft if relativeLeft < 0,
                                                                lcolor(red))
       (lfit demeanedConsumption relativeLeft if relativeLeft >= 0,
                                                                lcolor(red))
        ,
       ytitle("Demeaned consumption (kW h)")
       yscale(on)
       xtitle("Relative periods (0 = Left TVP)")
       title("")
       legend(off order(1 "Consumption (Demeaned)" 2 "Fitted line (in)"
                                            3 "Fitted line (out)" ) cols(3))
       xline(0)
;

graph export "$RUTA\figures\inOutScatter.png", replace
                                                  width(10000) height(8000);

#delimit cr


*** CONSUMPTION PATTERNS BEFORE LEAVING ****************************************

keep if treatment == 1

collapse demeanedConsumption, by(relativeLeft)

#delimit ;

twoway  (line demeanedConsumption relativeLeft, lpattern(solid)),
          ytitle("Demeaned consumption (kW h)")
          ttitle("Relative periods (0 = Left TVP)")
          yline(0, lpattern(dash))
          title("")
          ;

graph export "$RUTA\figures\consumptionBeforeExit.png", replace
                                            width(10000) height(8000);

#delimit cr

*** LEFT: PLOT # OBS IN EACH MONTH  ******************************************** FIGURE X

count if relativeLeft < 0   // 11485

count if relativeLeft >= 0  // 13480


egen nPeriod = count(year), by(relativeLeft)

#delimit ;

twoway  (spike nPeriod relativeLeft, sort fcolor(gs10)),
        title("")
        ylabel(,ang(h))
        ytitle("Number of observations")
        xtitle("Relative exit")
        ;

graph export "$RUTA\figures\inOutNPeriods.png", replace
                                                  width(10000) height(8000);

#delimit cr


*** TYPES 1,2: EVENT STUDY ***************************************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

keep if contractType == 1 | contractType == 2

gen join2 = join[_n-1] == 1

rename join2 first

* 6 MONTHS ---------------------------------------------------------------------

global LEADS "F6.first F5.first F4.first F3.first F2.first F.first"

global LAGS  "L.first L2.first L3.first L4.first L5.first L6.first"


xtreg consumption i.datevar $LEADS first $LAGS,  fe cluster(contract)

#delimit ;

coefplot, keep(F* first  L*)  yline(0) msymbol(d) mcolor(white)
          levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1))
          legend(order(1 "99%" 2 "95%" 3 "90%" )
                                  ring(0) pos(1) col(1) region(lcolor(none)))
          vertical
          title("")
          subtitle("")
          xtitle("Relative periods (0 = Join TVP)") ytitle(kW h) ylabel(,ang(h))
          xlabel(1 "-6" 4 "-3" 7 "0" 10 "3" 13 "6", labsize(small) )
          ;


graph export "$RUTA\figures\eventStudyType1-2_6months.png", replace
                                                   width(10000) height(8000);

test $LEADS;

// Prob > F = 0

test $LAGS;

// pvalue = .2869

#delimit cr



*** TYPE 2: EVENT STUDY ******************************************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

keep if contractType == 2

gen join2 = join[_n-1] == 1

rename join2 first

* 6 MONTHS ---------------------------------------------------------------------

global LEADS "F6.first F5.first F4.first F3.first F2.first F.first"

global LAGS  "L.first L2.first L3.first L4.first L5.first L6.first"


xtreg consumption i.datevar $LEADS first $LAGS,  fe cluster(contract)

#delimit ;

coefplot, keep(F* first  L*)  yline(0) msymbol(d) mcolor(white)
          levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1))
          legend(order(1 "99%" 2 "95%" 3 "90%" )
                                  ring(0) pos(1) col(1) region(lcolor(none)))
          vertical
          title("")
          subtitle("")
          xtitle("Relative periods (0 = Join TVP)") ytitle(kW h) ylabel(,ang(h))
          xlabel(1 "-6" 4 "-3" 7 "0" 10 "3" 13 "6", labsize(small) )
          ;


graph export "$RUTA\figures\eventStudyType2_6months.png", replace
                                                   width(10000) height(8000);

test $LEADS;

// Prob > F = 0

test $LAGS;

// pvalue = .5237

#delimit cr


*** TYPES 1,3: EVENT STUDY ***************************************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

keep if contractType == 1 | contractType == 3

gen left2 = left[_n-1] == 1

rename left2  first


* 6 MONTHS ---------------------------------------------------------------------

global LEADS "F6.first F5.first F4.first F3.first F2.first F.first"

global LAGS  "L.first L2.first L3.first L4.first L5.first L6.first"


xtreg consumption i.datevar $LEADS first $LAGS,  fe cluster(contract)

#delimit ;

coefplot, keep(F* first  L*)  yline(0) msymbol(d) mcolor(white)
          levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1))
          legend(order(1 "99%" 2 "95%" 3 "90%" )
                                  ring(0) pos(1) col(1) region(lcolor(none)))
          vertical
          title("")
          subtitle("")
          xtitle("Relative entry") ytitle(kW h) ylabel(,ang(h))
          xlabel(1 "-6" 4 "-3" 7 "0" 10 "3" 13 "6", labsize(small) )
          ;


graph export "$RUTA\figures\eventStudyType1-3_6months.png", replace
                                                   width(10000) height(8000);

test $LEADS;

// Prob > F = 0

test $LAGS;

// pvalue = .1496

#delimit cr


* 3 MONTHS ---------------------------------------------------------------------

global LEADS "F3.first F2.first F.first"

global LAGS  "L.first L2.first L3.first"


xtreg consumption i.datevar $LEADS first $LAGS,  fe cluster(contract)

#delimit ;

coefplot, keep(F* first  L*)  yline(0) msymbol(d) mcolor(white)
          levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1))
          legend(order(1 "99%" 2 "95%" 3 "90%" )
                                  ring(0) pos(1) col(1) region(lcolor(none)))
          vertical
          title("")
          subtitle("")
          xtitle("Relative periods (0 = Join TVP)") ytitle(kW h) ylabel(,ang(h))
          xlabel(1 "-3" 4 "Exit" 7 "3", labsize(small) )
          ;


graph export "$RUTA\figures\eventStudyType1-3_3months.png", replace
                                                   width(10000) height(8000);

test $LEADS;

// Prob > F = 0

test $LAGS;

// pvalue = .2533

#delimit cr


*** TYPES 3: EVENT STUDY ******************************************************* FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

keep if contractType == 3

gen left2 = left[_n-1] == 1

rename left2  first

* 24 MONTHS --------------------------------------------------------------------

global LEADS "F24.first F23.first F22.first F21.first F20.first F19.first F18.first F17.first F16.first F15.first F14.first F13.first F12.first F11.first F10.first F9.first F8.first F7.first F6.first F5.first F4.first F3.first F2.first F.first"

global LAGS  "L.first L2.first L3.first L4.first L5.first L6.first L7.first L8.first L9.first L10.first L11.first L12.first L13.first L14.first L15.first L16.first L17.first L18.first L19.first L20.first L21.first L22.first L23.first L24.first"


xtreg consumption i.datevar $LEADS first $LAGS,  fe cluster(contract)

#delimit ;

coefplot, keep(F* first  L*)  yline(0) msymbol(d) mcolor(white)
          levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1))
          legend(order(1 "99%" 2 "95%" 3 "90%" )
                                  ring(0) pos(1) col(1) region(lcolor(none)))
          vertical
          title("")
          subtitle("")
          xtitle("Relative periods (0 = Left TVP)") ytitle(kW h) ylabel(,ang(h))
          xlabel(1 "-24" 4 "-21" 7 "-18" 10 "-15" 13 "12" 16 "9" 19 "6" 22 "3"
          25 "Exit", labsize(small) )
          ;


graph export "$RUTA\figures\eventStudyType3_24months.png", replace
                                                   width(10000) height(8000);

test $LEADS;

// Prob > F = 0

test $LAGS;

// pvalue = .4399

#delimit cr

* 12 MONTHS --------------------------------------------------------------------

global LEADS "F12.first F11.first F10.first F9.first F8.first F7.first F6.first F5.first F4.first F3.first F2.first F.first"

global LAGS  "L.first L2.first L3.first L4.first L5.first L6.first L7.first L8.first L9.first L10.first L11.first L12.first"


xtreg consumption i.datevar $LEADS first $LAGS,  fe cluster(contract)

#delimit ;

coefplot, keep(F* first  L*)  yline(0) msymbol(d) mcolor(white)
          levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1))
          legend(order(1 "99%" 2 "95%" 3 "90%" )
                                  ring(0) pos(1) col(1) region(lcolor(none)))
          vertical
          title("")
          subtitle("")
          xtitle("Relative exit") ytitle(kW h) ylabel(,ang(h))
          xlabel(1 "-12" 4 "-9" 7 "-6" 10 "-3" 13 "Exit" 16 "3" 19 "6" 22 "9"
          25 "12", labsize(small) )
          ;


graph export "$RUTA\figures\eventStudyType3_12months.png", replace
                                                   width(10000) height(8000);

test $LEADS;

// Prob > F = 0

test $LAGS;

// pvalue = .4399

#delimit cr


* 6 MONTHS ---------------------------------------------------------------------

global LEADS "F6.first F5.first F4.first F3.first F2.first F.first"

global LAGS  "L.first L2.first L3.first L4.first L5.first L6.first"


xtreg consumption i.datevar $LEADS first $LAGS,  fe cluster(contract)

#delimit ;

coefplot, keep(F* first  L*)  yline(0) msymbol(d) mcolor(white)
          levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1))
          legend(order(1 "99%" 2 "95%" 3 "90%" )
                                  ring(0) pos(1) col(1) region(lcolor(none)))
          vertical
          title("")
          subtitle("")
          xtitle("Relative periods (0 = Left TVP)") ytitle(kW h) ylabel(,ang(h))
          xlabel(1 "-6" 4 "-3" 7 "0" 10 "3" 13 "6", labsize(small) )
          ;


graph export "$RUTA\figures\eventStudyType3_6months.png", replace
                                                   width(10000) height(8000);

test $LEADS;

// Prob > F = 0

test $LAGS;

// pvalue = .1548

#delimit cr


* 3 MONTHS ---------------------------------------------------------------------

global LEADS "F3.first F2.first F.first"

global LAGS  "L.first L2.first L3.first"


xtreg consumption i.datevar $LEADS first $LAGS,  fe cluster(contract)

#delimit ;

coefplot, keep(F* first  L*)  yline(0) msymbol(d) mcolor(white)
          levels(99 95 90) ciopts(lwidth(2 ..) lcolor(*.2 *.4 *.6 *.8 *1))
          legend(order(1 "99%" 2 "95%" 3 "90%" )
                                  ring(0) pos(1) col(1) region(lcolor(none)))
          vertical
          title("")
          subtitle("")
          xtitle("Relative periods (0 = Left TVP)") ytitle(kW h) ylabel(,ang(h))
          xlabel(1 "-3" 4 "Exit" 7 "3", labsize(small) )
          ;


graph export "$RUTA\figures\eventStudyType3_3months.png", replace
                                                   width(10000) height(8000);

test $LEADS;

// Prob > F = 0

test $LAGS;

// pvalue = .2514

#delimit cr



*** TOTAL CONSUMPTION BY TYPE OF CONTRACT ************************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

drop if contractType == 0

gen total1 = consumption if contractType == 1
gen total2 = consumption if contractType == 2
gen total3 = consumption if contractType == 3

collapse total*, by(datevar)


#delimit ;

twoway  (tsline total1, lpattern(solid) lcolor(black))
        (tsline total2, lpattern(shortdash) lcolor(red))
        (tsline total3, lpattern(longdash) lcolor(blue)),
          ytitle(kW h)
          ttitle("")
          ylabel(,ang(h))
          title("")
          legend( order(1 "Group I" 2 "Group J" 3 "Group L")
                          ring(0) pos(1) cols(1) region(lstyle(none)));


graph export "$RUTA\figures\totalTypeContract.png", replace
                                            width(10000) height(8000);

#delimit cr


*** DISAGGREGATE CONSUMPTION BY TYPE OF CONTRACT ******************************* FIGURE X

* ALWAYS IN THE PROGRAM --------------------------------------------------------

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

keep if contractType == 1

collapse punta valle nocturna, by(datevar)

gen puntaHourly = (punta/30) / 5

gen valleHourly = (valle/30) / 9

gen nocturnaHourly = (nocturna/30) / 10


#delimit ;

twoway  (tsline puntaHourly, lpattern(solid) lcolor(black))
        (tsline valleHourly, lpattern(shortdash) lcolor(red))
        (tsline nocturnaHourly, lpattern(longdash) lcolor(blue)),
          ytitle(kW h)
          ttitle("")
          ylabel(,ang(h))
          title("Group I")
          legend( order(1 "Peak" 2 "Mid-peak" 3 "Off-peak")
                                              cols(3) region(lstyle(none)))
          saving("$RUTA\figures\temp\disaggregatedALL.gph", replace)
          xsize(14) ysize(8);

#delimit cr

* JOINED THE PROGRAM -----------------------------------------------------------

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

keep if contractType == 2

collapse punta valle nocturna, by(datevar)

gen puntaHourly = (punta/30) / 5

gen valleHourly = (valle/30) / 9

gen nocturnaHourly = (nocturna/30) / 10


#delimit ;

twoway  (tsline puntaHourly, lpattern(solid) lcolor(black))
        (tsline valleHourly, lpattern(shortdash) lcolor(red))
        (tsline nocturnaHourly, lpattern(longdash) lcolor(blue)),
          ytitle(kW h)
          ttitle("")
          ylabel(,ang(h))
          title("Group J")
          legend( order(1 "Peak" 2 "Mid-peak" 3 "Off-peak")
                                              cols(3) region(lstyle(none)))
          saving("$RUTA\figures\temp\disaggregatedJoin.gph", replace)
          xsize(14) ysize(8);

#delimit cr

* LEFT THE PROGRAM -------------------------------------------------------------

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

keep if contractType == 3

collapse punta valle nocturna, by(datevar)

gen puntaHourly = (punta/30) / 5

gen valleHourly = (valle/30) / 9

gen nocturnaHourly = (nocturna/30) / 10

#delimit ;

twoway  (tsline puntaHourly, lpattern(solid) lcolor(black))
        (tsline valleHourly, lpattern(shortdash) lcolor(red))
        (tsline nocturnaHourly, lpattern(longdash) lcolor(blue)),
          ytitle(kW h)
          ttitle("")
          ylabel(,ang(h))
          title("Group L")
          legend( order(1 "Peak" 2 "Mid-peak" 3 "Off-peak")
                                              cols(3) region(lstyle(none)))
          saving("$RUTA\figures\temp\disaggregatedLeft.gph", replace)
          xsize(14) ysize(8);

* COMBINE ---------------------------------------------------------------------;

grc1leg "$RUTA\figures\temp\disaggregatedALL"
        "$RUTA\figures\temp\disaggregatedJoin"
        "$RUTA\figures\temp\disaggregatedLeft"
        ,
        cols(1)
        xcommon ycommon
        ;


graph export "$RUTA\figures\disaggregated.png", replace
                                            width(14000) height(14000);

#delimit cr

*** DISAGGREGATE CONSUMPTION BY TIME BLOCK ************************************* FIGURE X

* ALWAYS IN THE PROGRAM --------------------------------------------------------

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

drop if contractType == 0

gen peak1 = punta if contractType == 1
gen peak2 = punta if contractType == 2
gen peak3 = punta if contractType == 3

gen midPeak1 = valle if contractType == 1
gen midPeak2 = valle if contractType == 2
gen midPeak3 = valle if contractType == 3

gen offPeak1 = nocturna if contractType == 1
gen offPeak2 = nocturna if contractType == 2
gen offPeak3 = nocturna if contractType == 3


collapse peak* midPeak* offPeak*, by(datevar)

forvalues i = 1/3 {

  gen peak`i'Hourly = (peak`i'/30) / 5

  gen midPeak`i'Hourly = (midPeak`i'/30) / 9

  gen offPeak`i'Hourly = (offPeak`i'/30) / 10

}


#delimit ;

twoway  (tsline peak1Hourly, lpattern(solid) lcolor(black))
        (tsline peak2Hourly, lpattern(shortdash) lcolor(red))
        (tsline peak3Hourly, lpattern(longdash) lcolor(blue)),
          ytitle(kW h)
          ttitle("")
          ylabel(,ang(h))
          title("Peak")
          legend( order(1 "Group I" 2 "Group J" 3 "Group L")
                                              cols(3) region(lstyle(none)))
          saving("$RUTA\figures\temp\disaggregatedPeak.gph", replace)
          xsize(14) ysize(8);

twoway  (tsline midPeak1Hourly, lpattern(solid) lcolor(black))
        (tsline midPeak2Hourly, lpattern(shortdash) lcolor(red))
        (tsline midPeak3Hourly, lpattern(longdash) lcolor(blue)),
          ytitle(kW h)
          ttitle("")
          ylabel(,ang(h))
          title("Mid-peak")
          legend( order(1 "Group I" 2 "Group J" 3 "Group L")
                                              cols(3) region(lstyle(none)))
          saving("$RUTA\figures\temp\disaggregatedMidPeak.gph", replace)
          xsize(14) ysize(8);


twoway  (tsline offPeak1Hourly, lpattern(solid) lcolor(black))
        (tsline offPeak2Hourly, lpattern(shortdash) lcolor(red))
        (tsline offPeak3Hourly, lpattern(longdash) lcolor(blue)),
          ytitle(kW h)
          ttitle("")
          ylabel(,ang(h))
          title("Off-peak")
          legend( order(1 "Group I" 2 "Group J" 3 "Group L")
                                              cols(3) region(lstyle(none)))
          saving("$RUTA\figures\temp\disaggregatedOffPeak.gph", replace)
          xsize(14) ysize(8);


* COMBINE ---------------------------------------------------------------------;

grc1leg "$RUTA\figures\temp\disaggregatedPeak"
        "$RUTA\figures\temp\disaggregatedMidPeak"
        "$RUTA\figures\temp\disaggregatedOffPeak"
        ,
        cols(1)
        xcommon ycommon
        ;


graph export "$RUTA\figures\disaggregatedTimeBlock.png", replace
                                            width(14000) height(14000);

#delimit cr



*** REGRESSIONS **************************************************************** FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

drop if contractType == 0


* Estimates for HH that JOINED -------------------------------------------------

xtreg consumption i.datevar treatment if contractType == 2,                     ///
                                                          fe robust
  // b=67.89 | p=0.025

xtreg consumption i.datevar treatment if contractType == 2 | contractType == 1, ///
                                                          fe robust

    // b=24 | p=.19


* Estimates for HH that LEFT -------------------------------------------------

xtreg consumption i.datevar treatment if contractType == 3,                     ///
                                                          fe robust
  // b=16.28 | p=0.008

xtreg consumption i.datevar treatment if contractType == 3 | contractType == 1, ///
                                                          fe robust
    // b=6.83 | p=.209


*** BACON DECOMPOSITION OF DID ************************************************* FIGURE X
//
// use "$RUTA\data\bothNoOutliersXTNewType.dta", clear
//
// drop if contractType == 0
//
//
// bacondecomp consumption treatment if contractType == 2
//
// * NEEDS A STRONGLY BALANCED PANEL

*** BUNCHING ******************************************************************* FIGURE X

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

keep if contractType == 0

gen pricing = .
    replace pricing = 71.33 if consumption <= 200
    replace pricing = 109.46 if consumption > 200 & consumption <= 300
    replace pricing = 113.17 if consumption > 300

#delimit ;

twoway  (kdensity consumption )
        (line pricing consumption, lpattern(dash) sort yaxis(2)),
        ytitle("Density")
        ytitle(Marginal price per kW h, axis(2) orientation(rvertical))
        ylabel(none, ang(h))
        yscale(on)
        xtitle(kW h)
        title("")
        note("")
        legend(on order(1 "Consumption" 2 "Pricing scheme")
                                      region(lstyle(none)) ring(0) pos(1) )
        xline(200 300)
        ;

graph export "$RUTA\figures\bunchingControl.png", replace
                                                    width(10000) height(8000);

#delimit cr

*** END OF FILE ****************************************************************
********************************************************************************
