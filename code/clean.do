/*******************************************************************************
Project:
                                                                                PENDING

Authors:
TabareCapitan.com

Description:
Clean data

Input:
temp dta with all raw data

Output:
temp dta with all data ready to create panel

Created: 20180128 | Last modified: 20190804
*******************************************************************************/
version 14.2


*** VAR: PERIODO ***************************************************************

drop if periodo == "9-ENERGIA Y DEMANDA"		// Different category

gen timeBlock = .
	replace timeBlock = 4 if periodo == "4-REGULAR"
	replace timeBlock = 6 if periodo == "6-PUNTA HORARIA"
	replace timeBlock = 7 if periodo == "7-VALLE HORARIA"
	replace timeBlock = 8 if periodo == "8-NOCTURNA HORARIA"

drop periodo


*** RENAME/CAST VARS ***********************************************************

rename id_contrato contract

rename cantón canton

destring(loca), replace force
rename loca location

rename nombre name

destring(identificacion), replace force
rename identificacion cedula

rename telefono phone

destring(medidor), replace force // UNTESTED!
rename medidor meter

rename anio year

rename consumo_enero consumo1
rename consumo_febrero consumo2
rename consumo_marzo consumo3
rename consumo_abril consumo4
rename consumo_mayo consumo5
rename consumo_junio consumo6
rename consumo_julio consumo7
rename consumo_agosto consumo8
rename consumo_septiembre consumo9
rename consumo_octubre consumo10
rename consumo_noviembre consumo11
rename consumo_diciembre consumo12

cap rename estado status

cap rename fecha_inicio contractStartDate

cap rename fechatramcamtr lastRequestDate


cap drop tramcamtr

cap drop prom_cons_anual

cap drop prom_consumo

cap drop contractStartDate				// I might need this variable, but I need to drop to handle exact duplicates


*** REMOVE PERSONAL INFORMATION ************************************************

drop cedula name phone correo direccion


*** CHANGE ORDER ***************************************************************

order year sucursal timeBlock contract meter consumo*


*** END OF FILE ****************************************************************
********************************************************************************
