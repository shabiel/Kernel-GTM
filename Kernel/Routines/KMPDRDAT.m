KMPDRDAT ;SP/JML - Cover Sheet Load Raw Data Extract ;2018-06-11  2:57 PM
 ;;4.0;CAPACITY MANAGEMENT;*10003*;3/1/2018;Build 38
 ;
 ; *10003* (c) Sam Habiel 2018
 ; *10003 changes: Change VA email address to postmaster
 ;
 ; Send raw data to CPE database
 ; START TIME^FG DELTA^BG DELTA^TOT DELTA^CLIENT DUZ^CLIENT NAME^KMPTMP SUBSCRIPT KEY^APPLICATION TITLE^IP^DFN
 ;"KMPD","RDAT",
EN ;
 N KMPDBDLT,KMPDBGD,KMPDBGSS,KMPDDAT1,KMPDDATA,KMPDDELT,KMPDDOM,KMPDFDLT,KMPDFGBG,KMPDFGD,KMPDFGSS
 N KMPDFMDAY,KMPDHDAY,KMPDID,KMPDLN,KMPDP,KMPDPROD,KMPDSINF,KMPDSITE,KMPDSYS,KMPDTDLT,KMPDWD,Y
 ;
 K ^KMPTMP("KMPD","RDAT")
 S KMPDHDAY=+$H-1
 S KMPDFMDAY=+$$HTFM^XLFDT(KMPDHDAY,1)
 S KMPDWD=$$WORKDAY^XUWORKDY(KMPDFMDAY) ; IA#10046
 ;
 ; SET HEADER LINES
 S KMPDLN=1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="SYSTEM ID="_$$SITEINFO^KMPVCCFG(),KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="UPDATE CONFIG="_KMPDHDAY_U_KMPDWD_"^DAILY",KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="SYSTEM CONFIG="_$$SYSCFG^KMPVCCFG(),KMPDLN=KMPDLN+1
 ;
 ; DETERMINE FOREGROUND, BACKGROUND OR BOTH
 S KMPDFGBG=0,U="^"
 I $D(^KMPTMP("KMPDT","ORWCV")) S KMPDFGBG=1
 I $D(^KMPTMP("KMPDT","ORWCV-FT")) S KMPDFGBG=KMPDFGBG+2
 I KMPDFGBG=1 D ORONE("ORWCV")
 I KMPDFGBG=2 D ORONE("ORWCV-FT")
 I KMPDFGBG=3 D ORBOTH
 ;
 D TRANSMIT
 ;
 K ^KMPTMP("KMPD","RDAT")
 Q
 ;
ORONE(KMPDSUB) ;
 S KMPDID=""
 F  S KMPDID=$O(^KMPTMP("KMPDT",KMPDSUB,KMPDID)) Q:KMPDID=""  D
 .S KMPDDAT1=$G(^KMPTMP("KMPDT",KMPDSUB,KMPDID))
 .Q:$P(KMPDDAT1,U,5)=1
 .; identifier
 .S KMPDDATA=""
 .; server start date/time
 .S $P(KMPDDATA,U,1)=$P(KMPDDAT1,U)
 .;  (FG or BG delta) and (Total server delta)
 .D:$P(KMPDDAT1,U,2)
 ..S KMPDDELT=$$HDIFF^XLFDT($P(KMPDDAT1,U,2),$P(KMPDDAT1,U),2)
 ..S KMPDP=$S(KMPDSUB="ORWCV-FT":2,1:3)
 ..S $P(KMPDDATA,U,KMPDP)=KMPDDELT
 ..S $P(KMPDDATA,U,4)=KMPDDELT
 .; client duz
 .S $P(KMPDDATA,U,5)=$P(KMPDDAT1,U,3)
 .; client name
 .S $P(KMPDDATA,U,6)=$P(KMPDDAT1,U,4)
 .; kmptmp subscript key
 .S $P(KMPDDATA,U,7)=KMPDSUB
 .; application title
 .S $P(KMPDDATA,U,8)="CPRS Cover Sheet"
 .; ip address 
 .S $P(KMPDDATA,U,9)=$P($P(KMPDID,"-")," ",2)
 .; patient DFN
 .S $P(KMPDDATA,U,10)=$P(KMPDID,"-",3)
 .; START TIME^FG DELTA^BG DELTA^TOT DELTA^CLIENT DUZ^CLIENT NAME^KMPTMP SUBSCRIPT KEY^APPLICATION TITLE^IP^DFN
 .S ^KMPTMP("KMPD","RDAT",KMPDLN)="CVLOAD DATA="_KMPDDATA,KMPDLN=KMPDLN+1
 .S $P(^KMPTMP("KMPDT",KMPDSUB,KMPDID),U,5)=1
 Q
 ;
ORBOTH ;
 ; loop foreground node and concurrently look at related background node
 S KMPDBGSS="ORWCV",KMPDFGSS="ORWCV-FT"
 S KMPDID=""
 F  S KMPDID=$O(^KMPTMP("KMPDT",KMPDFGSS,KMPDID)) Q:KMPDID=""  D
 .S KMPDFGD=$G(^KMPTMP("KMPDT",KMPDFGSS,KMPDID))
 .Q:$P(KMPDFGD,U,5)=1  ;  ALREADY SENT
 .S KMPDBGD=$G(^KMPTMP("KMPDT",KMPDBGSS,KMPDID))
 .S KMPDDATA=""
 .S $P(KMPDDATA,U,1)=$P(KMPDFGD,U)
 .S (KMPDFDLT,KMPDBDLT,KMPDTDLT)=""
 .I $P(KMPDFGD,U,2) S KMPDFDLT=$$HDIFF^XLFDT($P(KMPDFGD,U,2),$P(KMPDFGD,U),2)
 .I $P(KMPDBGD,U,2) S KMPDBDLT=$$HDIFF^XLFDT($P(KMPDBGD,U,2),$P(KMPDBGD,U),2)
 .S KMPDTDLT=KMPDFDLT+KMPDBDLT
 .S $P(KMPDDATA,U,2)=KMPDFDLT
 .S $P(KMPDDATA,U,3)=KMPDBDLT
 .S $P(KMPDDATA,U,4)=KMPDTDLT
 .; client duz
 .S $P(KMPDDATA,U,5)=$P(KMPDFGD,U,3)
 .; client name
 .S $P(KMPDDATA,U,6)=$P(KMPDFGD,U,4)
 .; kmptmp subscript key
 .S $P(KMPDDATA,U,7)="ORWCV-FGBG"
 .; application title
 .S $P(KMPDDATA,U,8)="CPRS Cover Sheet"
 .; ip address
 .S $P(KMPDDATA,U,9)=$P($P(KMPDID,"-")," ",2)
 .; patient DFN
 .S $P(KMPDDATA,U,10)=$P(KMPDID,"-",3)
 .;  START TIME^FG DELTA^BG DELTA^TOT DELTA^CLIENT DUZ^CLIENT NAME^KMPTMP SUBSCRIPT KEY^APPLICATION TITLE^IP^DFN
 .S ^KMPTMP("KMPD","RDAT",KMPDLN)="CVLOAD DATA="_KMPDDATA,KMPDLN=KMPDLN+1
 .S $P(^KMPTMP("KMPDT",KMPDFGSS,KMPDID),U,5)=1
 .S $P(^KMPTMP("KMPDT",KMPDBGSS,KMPDID),U,5)=1
 ; Loop BG node in case there is an entry that didn't have a FG entry.
 ; The reverse situation already handled in first loop.
 D ORONE("ORWCV")
 Q
 ;
TRANSMIT ;
 ; quit if no data to transmit.
 Q:'$D(^KMPTMP("KMPD","RDAT"))
 N XMSUB,XMTEXT,XMY,XMZ
 ; send data via mail message.
 S XMTEXT="^KMPTMP(""KMPD"",""RDAT"","
 S XMSUB="CVLOAD DAILY DATA"
 S XMY(.5)="" ; *10003* ; was S XMY("S.KMPD-ORWCV-SERVER@VISTA.CPE.DOMAIN.EXT")=""
 D ^XMD
 Q
