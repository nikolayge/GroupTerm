* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
*   PGM-ID HELPCNRY
*   Help screen to display countries and country ISO codes
*
********************************************************
*                       MODIFICATION LOG
* USER DATE     TAG  REASON
* NGG  08272010 NG1  Initial Creation
********************************************************
DEFINE DATA
PARAMETER
1 #COUNTRY      (A50)
1 #COUNTRY-CODE (A2)
* LOCAL USING OBJAGENT
LOCAL

1 #CNRY-NAME        (A50/12)
1 #CNRY-SELECT      (A1/12)
1 #CNRY-CODE        (A2/12)

1 CNRY view of A-GEN-TABLE
  2 GEN-KEY                           (A4) /*    D
  2 GEN-SUB-KEY                       (A3)
  2 GEN-DESCRIPTION                   (A75)
1 #TABLE-KEY  (A7) 1 REDEFINE #TABLE-KEY
  2 #GEN-KEY         (A4)
  2 #SUB-KEY         (A3)

1 #PAGE              (I4)
1 #TOT-PAGES         (I4)
1 #I                 (I4)
1 #j                 (I4)
1 #L                 (I4)
1 #MAX-COUNTRIES     (I4)
1 #COUNTRY-CD-ARRAY (A60/*)

END-DEFINE
*
DEFINE WINDOW HELPWINDOW
  SIZE 19*60
  BASE 8/8
*
SET WINDOW 'HELPWINDOW'
SET KEY PF7 NAMED 'Up'
SET KEY PF8 NAMED 'Down'
SET KEY ENTR NAMED 'Slct'
SET KEY PF3 NAMED 'Retrn'
*
PERFORM POPULATE-COUNTRY-ARRAY
DIVIDE 12 INTO #MAX-COUNTRIES GIVING #TOT-PAGES REMAINDER #PAGE
IF #PAGE > 0
  ADD 1 TO #TOT-PAGES
END-IF
#PAGE := 1
#L := 1
PERFORM POPULATE-SCREEN-ARRAYS
INPUT USING MAP 'HLPMCNRY'
REPEAT UNTIL *PF-KEY = 'PF3'
  DECIDE ON FIRST VALUE OF *PF-KEY
    VALUE 'PF7'
      IF #PAGE > 1
        SUBTRACT 1 FROM #PAGE
        SUBTRACT 12 FROM #L
        PERFORM POPULATE-SCREEN-ARRAYS
      END-IF
    VALUE 'PF8'
      IF #MAX-COUNTRIES >= #L + 12
        ADD 1 TO #PAGE
        ADD 12 TO #L
        PERFORM POPULATE-SCREEN-ARRAYS
      END-IF
    VALUE 'ENTR'
      for #I 1 to 12
        if #CNRY-SELECT ( #I ) NE ' '
          #COUNTRY := #CNRY-NAME ( #I )
          #COUNTRY-CODE := #CNRY-CODE ( #I )
          ESCAPE BOTTOM
        end-if
      end-for
      escape bottom
    NONE VALUE IGNORE
  END-DECIDE
  INPUT USING MAP 'HLPMCNRY'
END-REPEAT

SET WINDOW OFF

DEFINE POPULATE-SCREEN-ARRAYS
RESET #CNRY-CODE (*) #CNRY-NAME (*)
ASSIGN #J = #L
FOR #I 1 TO 12
  #CNRY-CODE (#I) := SUBSTR( #COUNTRY-CD-ARRAY (#J),1,2)
  #CNRY-NAME (#I) := SUBSTR( #COUNTRY-CD-ARRAY (#J),4,50)
  ADD 1 TO #J
  IF #J > #MAX-COUNTRIES
    ESCAPE BOTTOM
  END-IF
END-FOR
END-SUBROUTINE

DEFINE SUBROUTINE POPULATE-COUNTRY-ARRAY
*                 ======================
RESET #COUNTRY-CD-ARRAY (*) #I
FIND NUMBER CNRY WITH GEN-KEY = 'COUN'
#MAX-COUNTRIES := *NUMBER
EXPAND ARRAY #COUNTRY-CD-ARRAY TO (*:#MAX-COUNTRIES)
FIND CNRY WITH GEN-KEY = 'COUN'
END-ALL
  AND SORT BY CNRY.GEN-DESCRIPTION USING CNRY.GEN-SUB-KEY
  ADD 1 TO #I
  COMPRESS CNRY.GEN-SUB-KEY ':' CNRY.GEN-DESCRIPTION INTO
    #COUNTRY-CD-ARRAY (#I) leaving no
END-SORT
END-SUBROUTINE

END
