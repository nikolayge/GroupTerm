* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
*
DEFINE DATA
PARAMETER
1 #PARM-NAME  (A65)
1 #CODE-TEXT  (A20)
1 #CODE       (A1)
LOCAL
1 #CODE-NAMES (A14/21) CONST <
  'ADDR-INTL',               /* 1
  'ADDR-LOCATION',           /* 2
  'ADDR-OVERRD',             /* 3   Y/N
  'ADDR-PROTECT',            /* 4
  'ADDR-RETURNED',           /* 5   Y/N
  'ADDR-TYPE',               /* 6
  'ADDR-VALID',              /* 7
  'EML-PREF',                /* 8   Y/N
  'EML-PROTECT',             /* 9   Y/N
  'EML-TYPE',                /* 10
  'EML-UNDLV',               /* 11  Y/N
  'PH-INTL',                 /* 12
  'PH-PREF',                 /* 13
  'PH-TIME',                 /* 14
  'PH-TYPE',                 /* 15
  'PH-VALID',                /* 16
  'ADDR-SOURCE',             /* 17
  'ADDR-STATUS',             /* 18
  'xxx',
  'EML-STATUS',              /* 20
  'ADDR-SHARE'               /* 21
  >
1 #CODES-DESC       (A25/12)
1 #CODE-SELECT      (A1/12)
1 #CODES            (A1/12)
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

* print #CODE-NAMES (1) #CODE-NAMES (2)
*  / #CODE-NAMES (3) #CODE-NAMES (4)
*  / #CODE-NAMES (5) #CODE-NAMES (6)
*  / #CODE-NAMES (7) #CODE-NAMES (8)
*  / #CODE-NAMES (9) #CODE-NAMES (10)
*  / #CODE-NAMES (11) #CODE-NAMES (12)
*  / #CODE-NAMES (13) #CODE-NAMES (14)
*  / #CODE-NAMES (15) #CODE-NAMES (16)
*  / #CODE-NAMES (17) #CODE-NAMES (18)
*  / #CODE-NAMES (19) #CODE-NAMES (20)
*  / #CODE-NAMES (21)

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
EXAMINE #PARM-NAME FOR '.' GIVING POSITION #L
#I := 65 - #L - 1
ADD 2 TO #L
#CODE-NAME := SUBSTR (#PARM-NAME,#L,#I)
EXAMINE #CODE-NAMES (*) FOR #CODE-NAME GIVING INDEX #TABLE-CODE
MOVE EDITED #TABLE-CODE (EM=999) TO #SUB-KEY
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
MOVE (AD=P) TO #CODE-SELECT-CV(*)
*
ASSIGN #J = #L
FOR #I 1 TO 12
  GET CODES #ISNS ( #J )
  #CODES (#I) := CODES.GEN-ALPHA-VALUE
  #CODES-DESC (#I) := CODES.ADDL-INFO
  MOVE (AD=DU) TO #CODE-SELECT-CV(#I)
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
EXAMINE #CODE-NAMES (*) FOR #CODE-NAME GIVING INDEX #TABLE-CODE
MOVE EDITED #TABLE-CODE (EM=999) TO #SUB-KEY
MOVE 'CODE' TO #GEN-KEY
FIND CODES WITH SEC-KEY = #TABLE-KEY
  #ISN := *ISN (0180)
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

END-SUBROUTINE

END
