* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
*   PGM-ID HELPDD02
*   Help screen to display drop downs from GEN-TABLE
*   (small list - no scrolling - by GEN-SUBKEY)
********************************************************
*                       MODIFICATION LOG
* USER DATE     TAG  REASON
* YAK  07202011 YK1  Initial Creation
* TMT  04022014 TT1  Increased Field Size
********************************************************
DEFINE DATA
PARAMETER
1 #VALUE-CD           (A1)
1 #VALUE              (A25)     /* TT1
1 #VALUE-LOOK-UP-KEY  (A7)
1 #WIN-LENGTH         (N2)
LOCAL USING OBJAGENT
*
LOCAL
1 #MAX-CODE   (N6)
1 #I          (N6)
1 #I1         (N6)
1 #TEXT       (A60)
1 #SEL        (A1/15)
1 #SCR-DESCRIPTION (A60/15)
1 #WIN-ROW    (I2)
END-DEFINE
*
PARM-GEN-TABLE.#SEC-KEY:= #VALUE-LOOK-UP-KEY
PARM-GEN-TABLE.#ACTION := 'HIST-SEC'
CALLNAT 'OBJNGENT' USING PARM-GEN-TABLE
RESIZE ARRAY PARM-ARRAY TO (*:#NUMBER-OF-RECORDS)
PARM-GEN-TABLE.#ACTION := 'R-ALPSEL'
CALLNAT 'OBJNGENT' USING PARM-GEN-TABLE
RESIZE ARRAY PARM-ARRAY TO (*:#NUMBER-OF-RECORDS)
*
#MAX-CODE := PARM-GEN-TABLE.#NUMBER-OF-RECORDS
*
#WIN-ROW := #MAX-CODE + 6
DEFINE WINDOW HELPWINDOW
  SIZE #WIN-ROW*#WIN-LENGTH
  BASE 8/18
*
SET KEY PF3 NAMED 'Retrn'
SET KEY ENTR NAMED 'Sel'
SET WINDOW 'HELPWINDOW'
*
PERFORM POPULATE-SCREEN
REPEAT
  INPUT WITH TEXT #TEXT USING MAP 'GPRMDD01'
  IF *PF-KEY = 'PF12' OR *PF-KEY = 'PF3'
    ESCAPE ROUTINE
  END-IF
  IF *PF-KEY = 'ENTR'
    EXAMINE #SEL(*) FOR 'X' INDEX #I
    IF #I = 0
      #I := *CURS-LINE
    END-IF
    IF #I >= 1
      #VALUE    := PARM-GEN-TABLE.ADDL-INFO(#I)
      #VALUE-CD := PARM-GEN-TABLE.GEN-ALPHA-VALUE(#I)
      SET WINDOW OFF
      ESCAPE ROUTINE
    END-IF
  ELSE
    PERFORM POPULATE-SCREEN
  END-IF
END-REPEAT
*
*********************************
DEFINE SUBROUTINE POPULATE-SCREEN
*********************************
*
RESET #SEL(*) #SCR-DESCRIPTION(*)
FOR #I = 1 TO #MAX-CODE
  #I1 := #I1 + 1
  #SEL(#I) := '_'
  COMPRESS PARM-GEN-TABLE.GEN-ALPHA-VALUE(#I) PARM-GEN-TABLE.ADDL-INFO(#I)
    INTO #SCR-DESCRIPTION(#I1)
END-FOR
END-SUBROUTINE
*
END
