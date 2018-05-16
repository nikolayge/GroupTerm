* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
*   PGM-ID HELPSTCD
*    Help screen to display states to select
*
********************************************************************************
*                       MODIFICATION LOG
* USER DATE     TAG  REASON
* YAK  08062007 YK1  Initial Creation
********************************************************************************
DEFINE DATA
PARAMETER
1 #STATE      (A25)
1 #STATE-CODE (A2)
LOCAL USING OBJLGENT
LOCAL
*
1 #STATE-CD-ARRAY (A25/*)
*
1 #MAX-STATE  (N2)
1 #MAX-SCREEN (N2)
1 #MAX-SCREEN-LINE (N2) INIT <13>
1 #I  (N2)
1 #I1 (N2)
1 #TEXT (A18)
1 #SCREEN (N1) INIT <0>
1 #SCR-STATE-CD(A25/13)
END-DEFINE
*
DEFINE WINDOW HELPWINDOW
      SIZE 19*25
      BASE 9/20
*
SET KEY PF7 NAMED 'Up'
SET KEY PF8 NAMED 'Down'
SET KEY PF12 NAMED 'Quit'
SET KEY PF3 NAMED 'Retrn'
SET WINDOW 'HELPWINDOW'
*
PERFORM POPULATE-STATE-ARRAY
#MAX-SCREEN := #MAX-STATE / #MAX-SCREEN-LINE
PERFORM POPULATE-SCREEN
REPEAT
  INPUT WITH TEXT #TEXT USING MAP 'STATECDE'
    IF *PF-KEY = 'PF12' OR *PF-KEY = 'PF3'
     ESCAPE ROUTINE
    END-IF
 IF *PF-KEY = 'ENTR'
     #I := *CURS-LINE
     IF #I < 1 OR #I > #MAX-SCREEN-LINE
        RESET #STATE-CODE #STATE
     ELSE
        #STATE-CODE := SUBSTRING(#SCR-STATE-CD(#I),2,2)
        #STATE      := SUBSTRING(#SCR-STATE-CD(#I),5)
     END-IF
     SET WINDOW OFF
*     SET KEY OFF
     ESCAPE ROUTINE
 ELSE
  IF *PF-KEY = 'PF8'
     IF #SCREEN = #MAX-SCREEN
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
  #TEXT := 'Enter to select'
  RESET #SCR-STATE-CD(*)
  FOR #I1 = 1 TO #MAX-SCREEN-LINE
   #I := #SCREEN * #MAX-SCREEN-LINE + #I1
   IF #I > #MAX-STATE
     ESCAPE BOTTOM
   ELSE
     #SCR-STATE-CD(#I1) := #STATE-CD-ARRAY(#I)
   END-IF
  END-FOR
END-SUBROUTINE
*
DEFINE SUBROUTINE POPULATE-STATE-ARRAY
*
  RESET #STATE-CD-ARRAY(*)
  FIND NUMBER GEN-TABLE-V WITH GEN-KEY = 'STCD'
  #MAX-STATE := *NUMBER
  EXPAND ARRAY #STATE-CD-ARRAY TO (*:#MAX-STATE)
  FIND GEN-TABLE-V WITH GEN-KEY = 'STCD'   
    #I := *COUNTER
    COMPRESS '_' GEN-TABLE-V.GEN-SUB-KEY '-' GEN-TABLE-V.GEN-ALPHA-VALUE into 
           #STATE-CD-ARRAY(#I) leaving no
  END-FIND
END-SUBROUTINE
*
END
