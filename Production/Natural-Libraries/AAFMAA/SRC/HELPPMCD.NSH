* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
*   PGM-ID HELPPMCD
*   Help screen to display service codes for PortaMedic
*
********************************************************
*                       MODIFICATION LOG
* USER DATE     TAG  REASON
* YAK  11122008 YK1  Initial Creation
********************************************************
DEFINE DATA
PARAMETER 1 #SERVICE-CODE (A3)
LOCAL USING OBJAGENT
*
LOCAL
1 #SERVICE-CODE-KEY   (A4) INIT <'PMCD'>
1 #MAX-CODE   (N6)
1 #MAX-LINES  (N2) INIT <15>
1 #MAX-SCREEN (N2)
1 #I          (N6)
1 #I1         (N6)
1 #TEXT       (A60)
1 #SCREEN     (N2) INIT <0>
1 #SCR-SERVICE-CD             (A3/15)
1 #SCR-SERVICE-CD-DESCRIPTION (A60/15)
END-DEFINE
*
PARM-GEN-TABLE.#KEY    := #SERVICE-CODE-KEY
PARM-GEN-TABLE.#ACTION := 'READ'
PARM-GEN-TABLE.#NUMBER-OF-RECORDS := 1
CALLNAT 'OBJNGENT' USING PARM-GEN-TABLE
*
#MAX-CODE := PARM-GEN-TABLE.#NUMBER-OF-RECORDS
#MAX-SCREEN := #MAX-CODE / #MAX-LINES
IF #MAX-SCREEN * #MAX-LINES < #MAX-CODE
  #MAX-SCREEN := #MAX-SCREEN + 1
END-IF  
*
DEFINE WINDOW HELPWINDOW
      SIZE 20*70
      BASE 5/5
*
SET KEY PF7 NAMED 'Up'
SET KEY PF8 NAMED 'Down'
SET KEY PF12 NAMED 'Quit'
SET KEY PF3 NAMED 'Retrn'
SET WINDOW 'HELPWINDOW'
*
PERFORM POPULATE-SCREEN
REPEAT
  INPUT WITH TEXT #TEXT USING MAP 'PMSERVCD'
    IF *PF-KEY = 'PF12' OR *PF-KEY = 'PF3'
     ESCAPE ROUTINE
    END-IF
 IF *PF-KEY = 'ENTR'
       #I := *CURS-LINE
     #SERVICE-CODE := #SCR-SERVICE-CD(#I)
     SET WINDOW OFF
*     SET KEY OFF
     ESCAPE ROUTINE
 ELSE
  IF *PF-KEY = 'PF8'
     IF #SCREEN = #MAX-SCREEN - 1
        #TEXT := 'Last screen'
        ESCAPE TOP
   ELSE
     #SCREEN := #SCREEN + 1
     PERFORM POPULATE-SCREEN
     ESCAPE TOP
   END-IF
  END-IF
  IF *PF-KEY = 'PF7'
     IF #SCREEN = 0
      #TEXT := 'First screen'
    ESCAPE TOP
     ELSE
       #SCREEN := #SCREEN - 1
             PERFORM POPULATE-SCREEN
             ESCAPE TOP
     END-IF
  END-IF
 END-IF
END-REPEAT
*
DEFINE SUBROUTINE POPULATE-SCREEN
*
  #TEXT := 'Select with cursor and hit "Enter"'
  RESET #SCR-SERVICE-CD(*) #SCR-SERVICE-CD-DESCRIPTION(*)
  FOR #I1 = 1 TO #MAX-LINES
   #I := #SCREEN * #MAX-LINES + #I1
   IF #I > #MAX-CODE
     ESCAPE BOTTOM
   ELSE
     #SCR-SERVICE-CD(#I1) := PARM-GEN-TABLE.GEN-SUB-KEY(#I)
     #SCR-SERVICE-CD-DESCRIPTION(#I1) := PARM-GEN-TABLE.GEN-DESCRIPTION(#I)
   END-IF
  END-FOR
END-SUBROUTINE
*
END
