* >Natural Source Header 000000
* :Mode S
* :CP ISO_8859-1:1987
* :LineIncrement 10
* <Natural Source Header
***************************************************************************************
* Program  :  ATXH0001
* FUNCTION : Help routine for CA applications. They have to have a disclosure document
* vxt 01062011 created
***************************************************************************************
DEFINE DATA PARAMETER
1 #DISCLOSURE-IND    (A1)
LOCAL
1 #TEXT   (A70)
END-DEFINE
*
if #disclosure-ind ne ' '
escape routine
end-if
*
define window ca-appl
  size quarter
  base top left
  framed on
  position symbol auto
*
INPUT TEXT #TEXT MARK *#DISCLOSURE-IND  USING MAP 'C1015MAT'
IF  not #DISCLOSURE-IND = 'Y' OR = 'N'
MOVE 'Please enter "Y" or "N" to continue' TO #TEXT
REINPUT #TEXT MARK *#DISCLOSURE-IND
end-if
*
reset #text
set window off
END
