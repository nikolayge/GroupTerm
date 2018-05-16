* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
************************************************************************
* NAME         : H-SALFAM                                              *
* AUTHOR       : Copyright: Electronic Data Systems                    *
* DESCRIPTION  : Help routine to over-ride EIL amounts                 *
************************************************************************
*
************************************************************************
*                       MODIFICATION LOG                               *
* USER   DATE      TAG     REASON                                      *
* PAM    07282008  None    Program Written                             *
************************************************************************
*
DEFINE DATA
PARAMETER
1 #APPROVAL-FLAG   (L/15)
1 #SCR-SSN-ID      (N9/15)
1 #I1              (I2)
1 #TRAN-AMOUNT     (N5.2)
*
LOCAL
1 #MINIMUM-AMOUNT  (N5.2)  INIT <107.25>
1 #DISPLAY-ID      (N9)
*
END-DEFINE
************************************************************************
DEFINE WINDOW CONFIRMATION-BOX
  SIZE 12*60
  BASE 5/7
*
SET WINDOW 'CONFIRMATION-BOX'
  SET KEY PF5  NAMED 'Accpt'
  #DISPLAY-ID := #SCR-SSN-ID (#I1)
  INPUT MARK *#TRAN-AMOUNT USING MAP 'CSALMSAM'
  IF #TRAN-AMOUNT GE #MINIMUM-AMOUNT
    IGNORE
  ELSE
    IF *PF-KEY = 'PF5'
      #APPROVAL-FLAG (#I1) := TRUE
    ELSE
      REINPUT 'Please press "F5" to override or change the payment amount'
      MARK *#TRAN-AMOUNT
    END-IF
  END-IF
  SET KEY PF2 = OFF
SET WINDOW OFF
*
END
