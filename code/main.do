/*******************************************************************************
Project:
                                                                                PENDING

Authors:
TabareCapitan.com

Description:
Controls the flow of the code

Created: 20190802 | Last modified: 20191009
*******************************************************************************/
version 14.2

*** PENDING ********************************************************************
***
*** SIMPLIFY TO ONLY ONE BIG DATASET WITH EVERYTHING
***
********************************************************************************

global RUTA "D:\Dropbox\T\r\CNFL"

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

run "$RUTA\code\createStataPanels.do"                                           // DONE

run "$RUTA\code\tagContractType.do"                                             // DONE

*** DATA ANALYSIS **************************************************************

run "$RUTA\code\paper.do"                                                       // IN PROGRESS


*** END OF FILE ****************************************************************
********************************************************************************
