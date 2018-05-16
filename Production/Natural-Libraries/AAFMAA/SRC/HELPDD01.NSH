* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
*   PGM-ID HELPDD01
*   Help screen to display any drop downs from GEN-TABLE
*
********************************************************
*                       MODIFICATION LOG
* USER DATE     TAG  REASON
* YAK  07202011 YK1  Initial Creation
********************************************************
DEFINE DATA
PARAMETER
1 #VALUE          (A19) /* Dynamic
* 1 #VALUE-KEY      (A4)
* 1 #VALUE-CODE     (A3)
LOCAL USING OBJAGENT
*
LOCAL
1 #MAX-CODE   (N6)
1 #MAX-LINES  (N2) INIT <15>
1 #MAX-SCREEN (N2)
1 #I          (N6)
1 #I1         (N6)
1 #TEXT       (A60)
1 #SCREEN     (N2) INIT <0>
1 #SEL        (A1/15)
1 #SCR-CODE   (A3/15)
1 #SCR-DESCRIPTION (A60/15)
1 #VALUE-KEY      (A4)
1 #VALUE-CODE     (A3)
END-DEFINE
*
#VALUE-KEY := 'EXTL'
PARM-GEN-TABLE.#KEY    := #VALUE-KEY
PARM-GEN-TABLE.#ACTION := 'HIST-KEY'
CALLNAT 'OBJNGENT' USING PARM-GEN-TABLE
RESIZE ARRAY PARM-ARRAY TO (*:#NUMBER-OF-RECORDS)
PARM-GEN-TABLE.#ACTION := 'READ-KEY'
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
  INPUT WITH TEXT #TEXT USING MAP 'GPRMDD01'
    IF *PF-KEY = 'PF12' OR *PF-KEY = 'PF3'
     ESCAPE ROUTINE
    END-IF
 IF *PF-KEY = 'ENTR'
     #I := *CURS-LINE
     #VALUE := #SCR-DESCRIPTION(#I)
     #VALUE-CODE := #SCR-CODE (#I)
     SET WINDOW OFF
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
  RESET #SCR-CODE(*) #SCR-DESCRIPTION(*)
  FOR #I1 = 1 TO #MAX-LINES
   #I := #SCREEN * #MAX-LINES + #I1
   IF #I > #MAX-CODE
     ESCAPE BOTTOM
   ELSE
     #SCR-CODE(#I1)        := PARM-GEN-TABLE.GEN-SUB-KEY(#I)
     #SCR-DESCRIPTION(#I1) := PARM-GEN-TABLE.GEN-DESCRIPTION(#I)
   END-IF
  END-FOR
END-SUBROUTINE
*
END
