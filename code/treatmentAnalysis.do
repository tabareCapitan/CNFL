/*******************************************************************************
Project: 		[PENDING]
Author: 		tabarecapitan.com
	
Description:	Analyze just treated contracts

Requires:		

Input:			None
Output:			None

Created:		20180411
Last modified:	20180411
*******************************************************************************/
version 14

clear

*** DESCRIPTIVE STATISTICS *****************************************************

use "$RUTA\data\treatmentNoOutliersXTtype.dta", clear


gen total = punta + valle + nocturna

sum total punta valle nocturna

by treatmentType, sort: sum total punta valle nocturna

* 

gen puntaHourly = punta / 5

gen valleHourly = valle / 9

gen nocturnaHourly = nocturna / 10

gen totalHourly = total / 24

sum totalH puntaH valleH nocturnaH

by treatmentType, sort: sum totalH puntaH valleH nocturnaH


*** PLOT CONSUMPTION PER BLOCK *************************************************

use "$RUTA\data\treatmentNoOutliersXTtype.dta", clear


preserve 

	collapse punta valle nocturna, by(datevar)

	gen puntaHourly = punta / 5

	gen valleHourly = valle / 9

	gen nocturnaHourly = nocturna / 10

	*** ALL DATA ***

	twoway (tsline puntaHourly) (tsline valleHourly) (tsline nocturnaHourly), 	///
		ytitle(Consumption (kw/hour)) 											///
		ttitle("") 																///
		title(Consumption per time block) 										///
		legend(order(1 "Peak" 2 "Valley" 3 "Night") cols(3)) 					///
		scheme(s2mono) 															///
		graphregion(fcolor(white))

		graph export "$RUTA\figuresTables\treatedAll.png", replace

restore

preserve 

	keep if treatmentType == 0

	collapse punta valle nocturna, by(datevar)

	gen puntaHourly = punta / 5

	gen valleHourly = valle / 9

	gen nocturnaHourly = nocturna / 10

	*** ALWAYS TREATED ***

	twoway (tsline puntaHourly) (tsline valleHourly) (tsline nocturnaHourly), 	///
		ytitle(Consumption (kw/hour)) 											///
		ttitle("") 																///
		title(Consumption per time block) 										///
		subtitle(Always treated)												///
		legend(order(1 "Peak" 2 "Valley" 3 "Night") cols(3)) 					///
		scheme(s2mono) 															///
		graphregion(fcolor(white))

		graph export "$RUTA\figuresTables\treatedAlways.png", replace

restore


preserve 

	keep if treatmentType == -1

	collapse punta valle nocturna, by(datevar)

	gen puntaHourly = punta / 5

	gen valleHourly = valle / 9

	gen nocturnaHourly = nocturna / 10

	*** LEFTERS ***

	twoway (tsline puntaHourly) (tsline valleHourly) (tsline nocturnaHourly), 	///
		ytitle(Consumption (kw/hour)) 											///
		ttitle("") 																///
		title(Consumption per time block) 										///
		subtitle(People who left the program)									///
		legend(order(1 "Peak" 2 "Valley" 3 "Night") cols(3)) 					///
		scheme(s2mono) 															///
		graphregion(fcolor(white))

		graph export "$RUTA\figuresTables\treatedLefters.png", replace

restore



preserve 

	keep if treatmentType == 1

	collapse punta valle nocturna, by(datevar)

	gen puntaHourly = punta / 5

	gen valleHourly = valle / 9

	gen nocturnaHourly = nocturna / 10

	*** JOINERS ***

	twoway (tsline puntaHourly) (tsline valleHourly) (tsline nocturnaHourly), 	///
		ytitle(Consumption (kw/hour)) 											///
		ttitle("") 																///
		title(Consumption per time block) 										///
		subtitle(People who joined the program)									///
		legend(order(1 "Peak" 2 "Valley" 3 "Night") cols(3)) 					///
		scheme(s2mono) 															///
		graphregion(fcolor(white))

		graph export "$RUTA\figuresTables\treatedJoiners.png", replace

restore
	
*** PLOT BLOCKS BETWEEN TYPES **************************************************

use "$RUTA\data\treatmentNoOutliersXTtype.dta", clear

preserve 

	keep if treatmentType == -1

	collapse punta valle nocturna, by(datevar)
	
	gen puntaLeft = punta / 5
	gen valleLeft = valle / 9
	gen nocturnaLeft = nocturna / 10
	
	savesome using "$RUTA\data\temp\treatedLeft.dta", replace

restore

preserve 

	keep if treatmentType == 0

	collapse punta valle nocturna, by(datevar)
	
	gen puntaAlways = punta / 5
	gen valleAlways = valle / 9
	gen nocturnaAlways = nocturna / 10
	
	savesome using "$RUTA\data\temp\treatedAlways.dta", replace

restore

preserve 

	keep if treatmentType == 1

	collapse punta valle nocturna, by(datevar)
	
	gen puntaJoin = punta / 5
	gen valleJoin = valle / 9
	gen nocturnaJoin = nocturna / 10
	
	savesome using "$RUTA\data\temp\treatedJoin.dta", replace

restore

*** APPEND EVERYTHING ***

use "$RUTA\data\temp\treatedLeft.dta", clear

merge 1:1 datevar using "$RUTA\data\temp\treatedAlways.dta"

drop _merge

merge 1:1 datevar using "$RUTA\data\temp\treatedJoin.dta"


*** PEAK BLOCK ***

twoway (tsline puntaLeft) (tsline puntaAlways) (tsline puntaJoin),				///
	ytitle(Consumption (kw/hour)) 												///
	ttitle("") 																	///
	title(Consumption by time block) 											///
	subtitle(Peak block)														///
	legend(order(1 "Left" 2 "Always" 3 "Join") cols(3)) 						///
	scheme(s2mono) 																///
	graphregion(fcolor(white))

graph export "$RUTA\figuresTables\treatedPeak.png", replace

*** Valley BLOCK ***

twoway (tsline valleLeft) (tsline valleAlways) (tsline valleJoin),				///
	ytitle(Consumption (kw/hour)) 												///
	ttitle("") 																	///
	title(Consumption by time block) 											///
	subtitle(Valley block)														///
	legend(order(1 "Left" 2 "Always" 3 "Join") cols(3)) 						///
	scheme(s2mono) 																///
	graphregion(fcolor(white))

graph export "$RUTA\figuresTables\treatedValley.png", replace

*** NIGHT BLOCK ***

twoway (tsline nocturnaLeft) (tsline nocturnaAlways) (tsline nocturnaJoin),		///
	ytitle(Consumption (kw/hour)) 												///
	ttitle("") 																	///
	title(Consumption by time block) 											///
	subtitle(Night block)														///
	legend(order(1 "Left" 2 "Always" 3 "Join") cols(3)) 						///
	scheme(s2mono) 																///
	graphregion(fcolor(white))

graph export "$RUTA\figuresTables\treatedNocturna.png", replace


*** END OF DOFILE **************************************************************
