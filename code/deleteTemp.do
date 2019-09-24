/*******************************************************************************
Project: 		[PENDING]
Author: 		tabarecapitan.com
	
Description:	Delete all temp files

Input:			
Output:			

Created:		20180129
Last modified:	20180129
*******************************************************************************/
version 14

clear

********************************************************************************

cd "$RUTA\data\temp\"

! dir *.dta /a-d /b >"$RUTA\data\temp\filelist.txt"

file open myfile using "$RUTA\data\temp\filelist.txt", read

file read myfile line

*use `line', clear

*save "$RUTA\rawAll.dta", replace

*file read myfile line

while r(eof) == 0 { 

	*append using `line', force
	erase `line'
	
	file read myfile line
}

file close myfile

*** END OF FILE ****************************************************************
********************************************************************************

