/*******************************************************************************
Project:
  Time-Varying Pricing May Increase Total Electricity Consumption:
  Evidence from Costa Rica

Author:
  TabareCapitan.com

Description:
  ...

---------------------------------------------
Created: 20210306 | Last modified: 20210308
*******************************************************************************/
version 14.2

use "$RUTA\data\bothNoOutliersXTNewType.dta", clear

drop if contractType == 0

*** SCALARS ********************************************************************

scalar BLOCK_0_30 = 2219.4

scalar BLOCK_31_200 = 73.98

scalar BLOCK_201_300 = 113.53

scalar BLOCK_301 = 117.37

*

scalar TVP_0_300_peak = 156.90

scalar TVP_0_300_mid = 65.05

scalar TVP_0_300_off = 26.78


scalar TVP_301_500_peak = 178.6

scalar TVP_301_500_mid = 72.72

scalar TVP_301_500_off = 30.62


scalar TVP_501_peak = 211.75

scalar TVP_501_mid = 85.47

scalar TVP_501_off = 39.55


*** COUNTERFACTUAL BILLING UNDER BLOCK PRICING *********************************

gen billing_block = .

  * 0-30 kW h

  replace billing_block = BLOCK_0_30 if inrange(consumption,0,30)

  * 31 - 200 kW h

  replace billing_block = BLOCK_0_30 +                                          ///
                          BLOCK_31_200 * (consumption - 30)                     ///
                          if inrange(consumption,31,200)

  * 201 kW h - 300 kW h

  replace billing_block = BLOCK_0_30 +                                          ///
                          BLOCK_31_200 * 170 +                                  ///
                          BLOCK_201_300 * (consumption - 200)                   ///
                          if inrange(consumption,201,300)

  * 301 kW h and up

  replace billing_block = BLOCK_0_30 +                                          ///
                          BLOCK_31_200  * 170 +                                 ///
                          BLOCK_201_300 * 100 +                                 ///
                          BLOCK_301 * (consumption - 300)                       ///
                          if consumption > 300 & !missing(consumption)

*** BILLING UNDER TVP **********************************************************

* Peak

gen billing_punta = .

  * 0-300 kW h

  replace billing_punta = TVP_0_300_peak * punta if inrange(punta,0,300)

  * 301 - 500 kW h

  replace billing_punta = TVP_0_300_peak   * 300 +                              ///
                          TVP_301_500_peak * (punta - 300)                      ///
                          if inrange(punta,301,500)

  * 501 kW h and up

  replace billing_punta = TVP_0_300_peak   * 300 +                              ///
                          TVP_301_500_peak * 200 +                              ///
                          TVP_501_peak     * (punta - 500)                      ///
                          if punta > 500 & !missing(punta)

* Mid-Peak

gen billing_valle = .

  * 0-300 kW h

  replace billing_valle = TVP_0_300_mid * valle if inrange(valle,0,300)

  * 301 - 500 kW h

  replace billing_valle = TVP_0_300_mid   * 300 +                               ///
                          TVP_301_500_mid * (valle - 300)                       ///
                          if inrange(valle,301,500)

  * 501 kW h and up

  replace billing_valle = TVP_0_300_mid   * 300 +                               ///
                          TVP_301_500_mid * 200 +                               ///
                          TVP_501_mid     * (valle - 500)                       ///
                          if valle > 500 & !missing(valle)

* Off-Peak

gen billing_nocturna = .

  * 0-300 kW h

  replace billing_nocturna = TVP_0_300_off * nocturna if inrange(nocturna,0,300)

  * 301 - 500 kW h

  replace billing_nocturna = TVP_0_300_off   * 300 +                            ///
                            TVP_301_500_off * (nocturna - 300)                  ///
                          if inrange(nocturna,301,500)

  * 501 kW h and up

  replace billing_nocturna = TVP_0_300_off   * 300 +                            ///
                             TVP_301_500_off * 200 +                            ///
                             TVP_501_off     * (nocturna - 500)                 ///
                             if nocturna > 500 & !missing(nocturna)

* Total bill

egen billing_TVP = rowtotal(billing_punta billing_valle billing_nocturna)

*** CALCULATE PRICES PER KWH ***************************************************

gen billing_avg_block = billing_block / consumption

gen billing_avg_TVP = billing_TVP /consumption


*** CLEAN UP STUFF *************************************************************

hist consumption if consumption > 30 & treatment == 1

hist billing_block  if consumption > 30 & treatment == 1

hist billing_TVP if consumption > 30 & treatment == 1

hist billing_avg_block if consumption > 30 & treatment == 1

hist billing_avg_TVP if consumption > 30 & treatment == 1 & billing_avg_TVP > 0

replace billing_avg_TVP = . if consumption > 0 & billing_avg_TVP == 0

save "$RUTA\data\dataWithBilling.dta", replace

*** GRAPH: Distribution differences TVP - BLOCK ********************************

gen dif = billing_TVP - billing_block


hist dif if consumption > 30 & treatment == 1 & dif > -80000 & dif < 9000,     ///
                        fraction                                                ///
                        ylabel(, ang(h))                                        ///
                        ytitle("Fraction")                                      ///
                        xtitle("Costa Rican Colones (CRC)")


graph export "$RUTA\figures\billing.png", replace width(10000) height(8000)


sum dif if consumption > 30 & treatment == 1 & contractType == 1

sum dif if consumption > 30 & treatment == 1 & contractType == 2

sum dif if consumption > 30 & treatment == 1 & contractType == 3


*** END OF FILE ****************************************************************
********************************************************************************
