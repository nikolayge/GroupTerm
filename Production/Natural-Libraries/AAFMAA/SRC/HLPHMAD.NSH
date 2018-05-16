* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* <Natural Source Header
/** New Helproutine HLPHMAD.
/**
/** :author nguentchev
/* 
*
DEFINE DATA
PARAMETER
1 #SUB-KEY-A  (A3)
1 #CODE-TEXT  (A24)  BY VALUE
1 #CODE       (A1)

LOCAL
1 #CODES-DESC       (A25/12)
1 #CODE-SELECT      (A1/12)
1 #CODES            (A2/12)
1 #CODE-SELECT-CV   (C/12)
1 #PAGE              (N2)
1 #TOT-PAGES         (N2)
1 #I                 (I4)
1 #j                 (I4)
1 #L                 (I4)
1 #MAX-CODES         (I4)
1 #TABLE-CODE        (I4)
1 #CODE-NAME         (A)  DYNAMIC

1 CODES view of A-GEN-TABLE
  2 GEN-KEY                           (A4) /*    D
  2 GEN-SUB-KEY                       (A3)
  2 GEN-ALPHA-VALUE                   (A50)
  2 GEN-DESCRIPTION                   (A75)
  2 ADDL-INFO
1 #TABLE-KEY  (A7)
1 REDEFINE #TABLE-KEY
  2 #GEN-KEY         (A4)
  2 #SUB-KEY         (A3)
1 #ISNS              (P8/99)
1 #HELP-DESC         (A22)
1 #ISN               (P8)
END-DEFINE
*
DEFINE WINDOW HELPWINDOW
  SIZE 19*35
  BASE 8/4
*
SET WINDOW 'HELPWINDOW'
SET KEY PF7  NAMED 'Up'
SET KEY PF8  NAMED 'Down'
SET KEY ENTR NAMED 'Slct'
SET KEY PF3  NAMED 'Retrn'
*
MOVE #SUB-KEY-A TO #SUB-KEY
MOVE 'CODE' TO #GEN-KEY

* PRINT
*  / #CODE-TEXT
*  / #CODE
*  / #TABLE-KEY
*
PERFORM POPULATE-CODES-ARRAY
*
IF #MAX-CODES <= 0
  SET WINDOW OFF
  ESCAPE ROUTINE
END-IF
*
DIVIDE 12 INTO #MAX-CODES GIVING #TOT-PAGES REMAINDER #PAGE
IF #PAGE > 0
  add 1 to #TOT-PAGES
end-if

#PAGE := 1
#TOT-PAGES := 1
#L := 1

PERFORM POPULATE-SCREEN-ARRAYS
INPUT USING MAP 'HLPMCODS'
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
        if #CODE-SELECT ( #I ) NE ' '
          #CODE := #CODES ( #I )
          #CODE-TEXT := #CODES-DESC (#I)
          ESCAPE BOTTOM
        end-if
      end-for
      escape bottom
    NONE VALUE IGNORE
  END-DECIDE
  INPUT USING MAP 'HLPMCODS'
END-REPEAT

SET WINDOW OFF

DEFINE POPULATE-SCREEN-ARRAYS
/*     ======================
RESET
  #CODES-DESC       (*)
  #CODE-SELECT      (*)
  #CODES            (*)
MOVE (AD=DU) TO #CODE-SELECT-CV(*)
*
ASSIGN #J = #L
FOR #I 1 TO 12
  GET CODES #ISNS ( #J )
  #CODES (#I) := CODES.GEN-ALPHA-VALUE
  #CODES-DESC (#I) := CODES.ADDL-INFO
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
  #ISNS          (*)
  #MAX-CODES

MOVE #SUB-KEY-A TO #SUB-KEY
MOVE 'CODE' TO #GEN-KEY
FIND CODES WITH SEC-KEY = #TABLE-KEY
  #ISN := *ISN (0142)
END-ALL
  AND SORT BY CODES.ADDL-INFO USING #ISN
  ADD 1 TO #MAX-CODES
  #ISNS ( #MAX-CODES ) := #ISN
END-SORT
*
* print #MAX-CODES

find (1) CODES WITH SEC-KEY = #TABLE-KEY
  #HELP-DESC := CODES.GEN-DESCRIPTION
end-find
*
END-SUBROUTINE
*
END
