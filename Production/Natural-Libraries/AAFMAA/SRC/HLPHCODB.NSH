* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
*
DEFINE DATA
PARAMETER
1 #SUB-KEY-A  (A3)
1 #CODE-TEXT  (A50)
1 #SECURED    (A1)
1 #ID-NUMBER  (N6)
1 #CODE       (A3)

LOCAL
1 #CODES-DESC       (A50/12)
1 #CODE-SELECT      (A1/12)
1 #CODES            (A3/12)
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
1 #PREV-CODE         (A1/20)

END-DEFINE

DEFINE WINDOW HELPWINDOW
  SIZE 19*58
  BASE 8/4
*
SET WINDOW 'HELPWINDOW'
SET KEY PF7  NAMED 'Up'
SET KEY PF8  NAMED 'Down'
SET KEY ENTR NAMED 'Slct'
SET KEY PF3  NAMED 'Retrn'
*
MOVE (AD=P) TO #CODE-SELECT-CV(*)
MOVE #SUB-KEY-A TO #SUB-KEY
MOVE 'CODE' TO #GEN-KEY

* INPUT (AD=IO) #CODE-NAME (EM=X(30))
*  / #CODE-TEXT
*  / #CODE
*  / #TABLE-KEY

PERFORM POPULATE-CODES-ARRAY

IF #MAX-CODES <= 0
  SET WINDOW OFF
  ESCAPE ROUTINE
END-IF

DIVIDE 12 INTO #MAX-CODES GIVING #TOT-PAGES REMAINDER #PAGE
IF #PAGE > 0
  add 1 to #TOT-PAGES
end-if

#PAGE := 1
#L := 1

PERFORM POPULATE-SCREEN-ARRAYS
INPUT USING MAP 'HLPMCODB'
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
      if #CODE-SELECT ( * ) NE ' '
        escape bottom
      END-IF
    NONE VALUE IGNORE
  END-DECIDE
  INPUT USING MAP 'HLPMCODB'
END-REPEAT

SET WINDOW OFF

DEFINE POPULATE-SCREEN-ARRAYS
/*     ======================
RESET
  #CODES-DESC       (*)
  #CODE-SELECT      (*)
  #CODES            (*)
MOVE (AD=P) TO #CODE-SELECT-CV(*)
*
ASSIGN #J = #L
FOR #I 1 TO 12
  GET CODES #ISNS ( #J )
  IF #ID-NUMBER = 0
    MOVE SUBSTR(CODES.GEN-ALPHA-VALUE,1,1) TO #CODES (#I)
  ELSE
    #CODES (#I) := CODES.GEN-ALPHA-VALUE
  END-IF
  #CODES-DESC (#I) := CODES.ADDL-INFO
  IF #SECURED = ' '
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
  #ISNS          (*)
  #MAX-CODES

MOVE #SUB-KEY-A TO #SUB-KEY
MOVE 'CODE' TO #GEN-KEY
FIND CODES WITH SEC-KEY = #TABLE-KEY
  IF #ID-NUMBER = 0
    IF SUBSTR(CODES.GEN-ALPHA-VALUE,1,1) = #PREV-CODE(*)
      ESCAPE TOP
    ELSE
      ADD 1 TO #I
      MOVE SUBSTR(CODES.GEN-ALPHA-VALUE,1,1) TO #PREV-CODE(#I)
    END-IF
  END-IF
  #ISN := *ISN (0152)
END-ALL
*  AND SORT BY CODES.ADDL-INFO USING #ISN
  AND SORT BY CODES.GEN-ALPHA-VALUE USING #ISN
  ADD 1 TO #MAX-CODES
  #ISNS ( #MAX-CODES ) := #ISN
END-SORT
*
* print #MAX-CODES

find (1) CODES WITH SEC-KEY = #TABLE-KEY
  #HELP-DESC := CODES.GEN-DESCRIPTION
end-find

END-SUBROUTINE

END
