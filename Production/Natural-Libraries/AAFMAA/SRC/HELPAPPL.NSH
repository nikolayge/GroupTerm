* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
* Help routine for application source
*
DEFINE DATA
PARAMETER
1 #CODE-TEXT         (A40)  BY VALUE
1 #SECURED           (A1)
1 #SOURCE-CODE       (A7)
*
LOCAL
1 #CODES-DESC       (A40/12)
1 #CODE-SELECT      (A1/12)
1 #CODES            (A6/12)
1 #CODE-SELECT-CV   (C/12)
1 #PAGE              (N2)
1 #TOT-PAGES         (N2)
1 #I                 (I4)
1 #j                 (I4)
1 #L                 (I4)
1 #MAX-CODES         (I4)
1 #TABLE-CODE        (I4)
1 #CODE-NAME         (A)  DYNAMIC
*
1 CODES VIEW OF A-SOURCE-OF-APPL
  2 SOURCE-CODE-GROUP (A1)
  2 SOURCE-CODE (A6)
  2 SOURCE-DESCRIPTION (A40)
  2 SOURCE-INQUIRIES-FLAG (P1.0)
*
1 #TABLE-KEY  (A7)
1 REDEFINE #TABLE-KEY
  2 #GEN-KEY         (A4)
  2 #SUB-KEY         (A3)
1 #ISNS              (P8/199)
1 #HELP-DESC         (A22)
1 #ISN               (P8)
*
END-DEFINE
*
DEFINE WINDOW HELPWINDOW
  SIZE 19*55
  BASE 8/4
*
SET WINDOW 'HELPWINDOW'
SET KEY PF7  NAMED 'Up'
SET KEY PF8  NAMED 'Down'
SET KEY ENTR NAMED 'Slct'
SET KEY PF3  NAMED 'Retrn'
*
* INPUT (AD=IO) #CODE-NAME (EM=X(30))
*  / #CODE-TEXT
*  / #SOURCE-CODE
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
*
#PAGE := 1
#TOT-PAGES := 1
#L := 1
*
PERFORM POPULATE-SCREEN-ARRAYS
INPUT USING MAP 'HLPMAPPL'
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
          #SOURCE-CODE := #CODES ( #I )
          #CODE-TEXT   := #CODES-DESC (#I)
          ESCAPE BOTTOM
        end-if
      end-for
      escape bottom
    NONE VALUE IGNORE
  END-DECIDE
  INPUT USING MAP 'HLPMAPPL'
END-REPEAT
*
SET WINDOW OFF
*
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
  #CODES (#I) := CODES.SOURCE-CODE
  #CODES-DESC (#I) := CODES.SOURCE-DESCRIPTION
  IF #SECURED = ' '
    MOVE (AD=DU) TO #CODE-SELECT-CV(#I)
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
*
READ CODES 
  ACCEPT IF CODES.SOURCE-CODE-GROUP = MASK (A)
  #ISN := *ISN (0138)
END-ALL
  AND SORT BY CODES.SOURCE-DESCRIPTION USING #ISN
  ADD 1 TO #MAX-CODES
  #ISNS ( #MAX-CODES ) := #ISN
END-SORT
*
* print #MAX-CODES
*
#HELP-DESC := 'Application Source'
*
END-SUBROUTINE
*
END
