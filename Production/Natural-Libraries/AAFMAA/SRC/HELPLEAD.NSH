* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
DEFINE DATA
PARAMETER
1 #LEAD-TYPE     (A4)
*
LOCAL
1 #LEAD-CODE     (A1)
*
END-DEFINE
*
DEFINE WINDOW HELPWINDOW1
  SIZE 10*20
  BASE 6/16
*
REPEAT
  FORMAT PS=008 LS=031 ZP=OFF SG=OFF KD=OFF IP=OFF
  INPUT          (     IP=OFF      )
    004T '* LEAD TYPE *'
    /
    /
    004T 'H'(I) 006T '- Hot'
    /
    004T 'W'(I) 006T '- Warm'
    /
    004T 'C'(I) 006T '- Cold'
    /
    002T 'Please Enter a Code'
    022T #LEAD-CODE  (AD=DLMFHT' ' ) /*.99U001 A001 .
    /
    002T 'Press'
    008T 'Enter to continue'(I)
    /
  IF *PF-KEY = 'ENTR'
    DECIDE ON FIRST VALUE #LEAD-CODE
      VALUE 'H'
        #LEAD-TYPE := 'HOT'
      VALUE 'W'
        #LEAD-TYPE := 'WARM'    
      VALUE 'C'
        #LEAD-TYPE := 'COLD'    
      NONE
        IF #LEAD-TYPE = ' '
           #LEAD-TYPE := 'COLD'
        END-IF   
    END-DECIDE
    ESCAPE ROUTINE
  END-IF
END-REPEAT
*
END
