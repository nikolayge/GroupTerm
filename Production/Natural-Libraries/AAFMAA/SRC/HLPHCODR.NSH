* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
*
DEFINE DATA
PARAMETER
1 #RANK-MIL-ID  (A3)
1 #CODE-TEXT    (A45)
1 #CODE         (A10)
1 #PAY-GRADE    (A3)
1 #RANK-ID      (N6)
1 #RETURN-FLAG  (L)
1 #SECURED      (A1)
LOCAL
1 #CODES-DESC       (A45/12)
1 #CODE-SELECT      (A1/12)
1 #CODES            (A10/12)
1 #PG               (A3/12)
1 #SPI              (A1/12)
1 #R-ID             (N6/12)
1 #CODE-SELECT-CV   (C/12)
1 #PAGE              (N2)
1 #TOT-PAGES         (N2)
1 #I                 (I4)
1 #j                 (I4)
1 #L                 (I4)
1 #MAX-CODES         (I4)
1 #TABLE-CODE        (I4)
1 #CODE-NAME         (A)  DYNAMIC

1 RANK-V VIEW OF A-RANK-REFERENCE
  2 RANK-ID
  2 MILITARY-ID
  2 MILITARY-BRANCH
  2 RANK-ABBR
  2 RANK-DESCRIPTION
  2 PAY-GRADE
  2 SPECIAL-PAY-IND
1 #ISNS              (P8/99)
1 #HELP-DESC         (A22)
1 #ISN               (P8)
1 #CODE-BRANCH       (A25)
1 BLANK              (A1) CONST <' '>
END-DEFINE
DEFINE WINDOW HELPWINDOW
  SIZE 19*68
  BASE 8/4
*
SET WINDOW 'HELPWINDOW'
SET KEY PF7  NAMED 'Up'
SET KEY PF8  NAMED 'Down'
SET KEY ENTR NAMED 'Slct'
SET KEY PF3  NAMED 'Retrn'

PERFORM POPULATE-CODES-ARRAY

IF NOT #RETURN-FLAG
  MOVE TRUE TO #RETURN-FLAG
  SET WINDOW OFF
  SET CONTROL 'Q'
  ESCAPE ROUTINE
END-IF

IF #MAX-CODES <= 0
  SET WINDOW OFF
  ESCAPE ROUTINE
END-IF

DIVIDE 12 INTO #MAX-CODES GIVING #TOT-PAGES REMAINDER #PAGE
IF #PAGE > 0
  add 1 to #TOT-PAGES
end-if
*
#PAGE := 1
#L := 1
*
PERFORM POPULATE-SCREEN-ARRAYS
INPUT USING MAP 'HLPMCODR'
REPEAT UNTIL *PF-KEY = 'PF3'
  DECIDE ON FIRST VALUE OF *PF-KEY
    VALUE 'PF7'
      IF #PAGE > 1
        SUBTRACT 1 FROM #PAGE
        SUBTRACT 12 FROM #L
        PERFORM POPULATE-SCREEN-ARRAYS
      END-IF
    VALUE 'PF8'
      IF #MAX-CODES >= #L + 12
        ADD 1 TO #PAGE
        ADD 12 TO #L
        PERFORM POPULATE-SCREEN-ARRAYS
      END-IF
    VALUE 'ENTR'
      for #I 1 to 12
        if #CODE-SELECT ( #I ) NE BLANK
          #CODE := #CODES ( #I )
          #CODE-TEXT := #CODES-DESC (#I)
          #PAY-GRADE := #PG (#I)
          #RANK-ID := #R-ID (#I)
          ESCAPE BOTTOM
        end-if
      end-for
      IF #CODE-SELECT ( * ) NE BLANK
        ESCAPE BOTTOM
      END-IF
    NONE VALUE IGNORE
  END-DECIDE
  INPUT USING MAP 'HLPMCODR'
END-REPEAT
RESET #RETURN-FLAG
*
SET WINDOW OFF

DEFINE POPULATE-SCREEN-ARRAYS
/*     ======================
RESET
  #CODES-DESC       (*)
  #CODE-SELECT      (*)
  #CODES            (*)
  #PG               (*)
  #SPI              (*)
MOVE (AD=P) TO #CODE-SELECT-CV(*)
*
ASSIGN #J = #L
FOR #I 1 TO 12
  GET RANK-V #ISNS ( #J )
  #CODES (#I) := RANK-ABBR
  #CODES-DESC (#I) := RANK-DESCRIPTION
  #PG (#I) := PAY-GRADE
  #SPI (#I) := SPECIAL-PAY-IND
  #R-ID (#I) := RANK-ID
  IF #SECURED = BLANK
    MOVE (AD=U) TO #CODE-SELECT-CV(#I)
  END-IF
  ADD 1 TO #J
  IF #J > #MAX-CODES
    ESCAPE BOTTOM
  END-IF
END-FOR
END-SUBROUTINE

DEFINE SUBROUTINE POPULATE-CODES-ARRAY
*                 ====================
RESET
  #CODES-DESC    (*)
  #CODE-SELECT   (*)
  #CODES         (*)
  #PG            (*)
  #SPI           (*)
  #ISNS          (*)
  #MAX-CODES
IF #RANK-MIL-ID = BLANK
  #RANK-MIL-ID := 'V'
END-IF
READ RANK-V
  IF SUBSTR(MILITARY-ID,1,1) NE SUBSTR(#RANK-MIL-ID,1,1)
    ESCAPE TOP
  END-IF
  MOVE MILITARY-BRANCH TO #CODE-BRANCH
  #ISN := *ISN (0157)
END-ALL
  AND SORT BY RANK-ID USING #ISN
  ADD 1 TO #MAX-CODES
  #ISNS ( #MAX-CODES ) := #ISN
END-SORT
*
END-SUBROUTINE

END
