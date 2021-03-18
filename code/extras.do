/*******************************************************************************
Project:
  Time-Varying Pricing May Increase Total Electricity Consumption:
  Evidence from Costa Rica

Author:
  TabareCapitan.com

Description:
  ...

---------------------------------------------
Created: 20210309 | Last modified: 20210309
*******************************************************************************/
version 14.2


use "$RUTA\data\dataWithBilling.dta", clear

keep if treatment == 1

*** MEAN AVERAGE PRICE UNDER TVP AND BLOCK PRICING *****************************

sum billing_avg_block if consumption > 30


sum billing_avg_TVP if consumption > 30 & billing_avg_TVP > 0

sum billing_avg_TVP if consumption > 30 & contractType == 1
sum billing_avg_TVP if consumption > 30 & contractType == 2
sum billing_avg_TVP if consumption > 30 & contractType == 3

*** TOTAL SAVINGS UNDER TVP ****************************************************

codebook contract  // 7,487 different households

scalar HHs = 7487

count              // 315,265 number of bills

scalar bills = `r(N)'
count if dif >0

di bills/HHs // 42 months per contract

* UNDER BLOCK PRICING ----------------------------------------------------------

qui sum billing_block

di "`r(mean)'" // CRC 40,624.84458141628 avg monthly bill

di "`r(sum)'" // CRC 12,807,591,626.96021 total payments

di `r(sum)'/HHs // CRC 1,710,644 per HH over the period

* UNDER TVP PRICING ------------------------------------------------------------

qui sum billing_TVP

di "`r(mean)'" // CRC 28,220.87338119014 avg monthly bill

di "`r(sum)'" // CRC 8,897,053,646.520908 total payments

di `r(sum)'/HHs // CRC 1,188,333.6 per HH over the period

* SAVINGS ----------------------------------------------------------------------

gen dif = billing_TVP - billing_block

qui sum dif, de

di "`r(mean)'" // CRC 12,403.97120009926 savings per month
di 12403*12

di "`r(sum)'" // CRC 3,910,537,980.399292 total savings

di `r(sum)'/ HHs // CRC 522,310.4 per household over the period

*** SHARE OF CONSUMPTION IN EACH TIME BLOCK ************************************

drop if consumption == 0

drop if punta == 0

drop if valle == 0

drop if nocturna == 0

gen sharePunta    = punta/consumption
gen shareValle    = valle/consumption
gen shareNocturna = nocturna/consumption

sum share*


*** END OF FILE ****************************************************************
********************************************************************************
