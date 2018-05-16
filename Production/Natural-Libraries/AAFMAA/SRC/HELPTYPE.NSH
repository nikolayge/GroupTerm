* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
DEFINE DATA
PARAMETER
1 #ADDR-FORMAT-TYPE     (A20)
1 #ADDR-FORMAT-CODE     (A1)
*
LOCAL
1 #TYPE-ARRAY (A20/2)
1 #MAX-ADDR-FORMAT-TYPE (N2) INIT < 2 >
1 #ADDR-FORMAT-TYPE-GROUP
 2 #ADDR-FORMAT-TYPE-ARRAY (A20/2) INIT <
   'Domestic',                         /* 1
   'International'>                    /* 2
 2 #ADDR-FORMAT-TYPE-CD-ARRAY (A1/2)
   INIT < '1', '2' >
*
1 #I (N2)
1 #CV-TYPE (C)
*
END-DEFINE
*
DEFINE WINDOW HELP-ADDR-FORMAT-TYPE
      SIZE 6*22
      BASE 7/18
*
   SET WINDOW 'HELP-ADDR-FORMAT-TYPE'
   FOR #I =1 TO #MAX-ADDR-FORMAT-TYPE
     #TYPE-ARRAY(#I) := #ADDR-FORMAT-TYPE-ARRAY(#I)
   END-FOR
*
 REPEAT
    INPUT WITH TEXT 'Enter to select' MARK *#ADDR-FORMAT-TYPE-ARRAY(1)
     USING MAP 'ADDRTYPE'
      DECIDE ON FIRST VALUE *PF-KEY 
        VALUE 'ENTR' 
          #I := *CURS-LINE
          #ADDR-FORMAT-CODE := #ADDR-FORMAT-TYPE-CD-ARRAY(#I)
          #ADDR-FORMAT-TYPE := #ADDR-FORMAT-TYPE-ARRAY(#I)        
        VALUE 'PF12', 'PF3'
          IGNORE
        NONE VALUE
          ESCAPE TOP
      END-DECIDE     
      SET WINDOW OFF      
      ESCAPE ROUTINE      
 END-REPEAT
END
