* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
************************************************************************
* NAME         : H-TRMFPF                                              *
* AUTHOR       : Copyright: Electronic Data Systems                    *
* DESCRIPTION  : Help routine to over-ride Term Insurance FPF amounts  *
************************************************************************
*
************************************************************************
*                       MODIFICATION LOG                               *
* USER   DATE      TAG     REASON                                      *
* PAM    10062008  None    Program Written                             *
************************************************************************
*
DEFINE DATA
PARAMETER
1 #APPROVAL-FLAG   (L)
1 #I1              (I2)
1 #FPF-END         (A8)
1 REDEFINE #FPF-END
 2 #FPF-MM         (A2)
 2 #FPF-DD         (A2)
 2 #FPF-YYYY       (A4)
1 REDEFINE #FPF-END
 2 #FPF-END-N      (N8)
1 #HOLD-FPF-END    (N8)
1 REDEFINE #HOLD-FPF-END
 2 #HOLD-FPF-MM    (A2)
 2 #HOLD-FPF-DD    (A2)
 2 #HOLD-FPF-YYYY  (A4)
1 #EFF-MMDDYYYY    (A8)
1 REDEFINE #EFF-MMDDYYYY
 2 #EFF-MM         (A2)
 2 #EFF-DD         (A2)
 2 #EFF-YYYY       (A4)
*
LOCAL USING C2012LNM
LOCAL
1 #ERROR-TEXT      (A58)
1 #ERROR-TEXT-2    (A58)
1 #DISPLAY-ISSUE   (A10)
1 #DISPLAY-FPF-END (A10)
1 #DISPLAY-HOLD-FPF(A10)
*
END-DEFINE
************************************************************************
DEFINE WINDOW CONFIRMATION-BOX
  SIZE 15*60
  BASE 5/7
*
IF #I1 = 0
  ESCAPE ROUTINE
END-IF
*
#ERROR-TEXT     := #C2012SNM-ERROR-MESSAGE (#I1)
IF #I1 = 1
  #ERROR-TEXT-2 := #C2012SNM-ERROR-MESSAGE (#I1+1)
ELSE
  RESET #ERROR-TEXT-2
END-IF
*
COMPRESS #EFF-MM #EFF-DD #EFF-YYYY INTO #DISPLAY-ISSUE WITH '/'
COMPRESS #FPF-MM #FPF-DD #FPF-YYYY INTO #DISPLAY-FPF-END WITH '/'
COMPRESS #HOLD-FPF-MM #HOLD-FPF-DD #HOLD-FPF-YYYY INTO #DISPLAY-HOLD-FPF
         WITH '/'
*
SET WINDOW 'CONFIRMATION-BOX'
  SET KEY PF5  NAMED 'Accpt'
  SET KEY PF3  NAMED 'Quit'
*
  INPUT USING MAP 'HELPMFPF'
  DECIDE FOR FIRST CONDITION
    WHEN *PF-KEY = 'PF3'
      RESET #APPROVAL-FLAG
    WHEN *PF-KEY = 'PF5'
      #APPROVAL-FLAG := TRUE
      #FPF-END-N     := #HOLD-FPF-END
    WHEN NONE
      REINPUT 'Please press "F5" to override or "F3" to make changes'
      MARK *#APPROVAL-FLAG
  END-DECIDE
*
  SET KEY PF5 = OFF
  SET KEY PF3 = OFF
SET WINDOW OFF
*
END
