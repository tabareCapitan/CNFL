/*******************************************************************************
Project:
                                                                                PENDING

Authors:
TabareCapitan.com

Description:
Controls the flow of the code

Created: 20190802 | Last modified: 20190929
*******************************************************************************/
version 14.2

*** ISSUES *********************************************************************
***
*** I'm not dealing with the Activo or Inactivo. Not sure what is that. Very
*** important with extra obs
***
*** Adding extra obs, check again everything from scratch! it is sketchy!
***
********************************************************************************

global RUTA "D:\Dropbox\research\_active\CNFL"

run "$RUTA\code\settings.do"

*** NEW PROGRAMS ***************************************************************

run "$RUTA\code\installNewPrograms.do"                                          // PENDING

*** DATA MANAGEMENT ************************************************************

run "$RUTA\code\importData.do"                                                  // DONE

run "$RUTA\code\createPanels.do"                                                // DONE

  * -> do "$RUTA\code\clean.do" (subcall)

run "$RUTA\code\appendAll.do"                                                   // PENDING

*run "$RUTA\code\deleteTemp.do"                                                  // PENDING

run "$RUTA\code\deleteOutliers.do"                                              // PENDING

run "$RUTA\code\createStataPanels.do"                                           // PENDING

*run "$RUTA\code\classifyTreatment.do"                                          // PENDING

run "$RUTA\code\tagContractType.do"                                             // DONE

*** DATA ANALYSIS **************************************************************

run "$RUTA\code\paper.do"                                                       // IN PROGRESS


***
run "$RUTA\code\treatmentAnalysis.do"                                           // PENDING

run "$RUTA\code\regressionAnalysis.do"                                          // PENDING

run "$RUTA\code\bothAnalysis.do"                                                // USED ALL


*** END OF FILE ****************************************************************
********************************************************************************
