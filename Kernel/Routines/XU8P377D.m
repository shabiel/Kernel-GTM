XU8P377D ;BT/BP-OAK - UPDATE PERSON CLASS FILE; [3/1/2005]
 ;;8.0;KERNEL;**377,411**;JULY 10, 1995;Build 2
 ;
EN ;
 N XU1,XU2,XUPCIEN,XUDATA
 F XU1=1:1:19 S XUDATA=$P($T(INAC+XU1),";",3,99) D
 . F XU2=1:1 S XUPCIEN=$P(XUDATA,";",XU2) Q:XUPCIEN="$END$"  D CHCK
 Q
INAC ;;
 ;;1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;17;18;19;20;21;$END$
 ;;22;23;26;27;28;29;30;31;32;33;34;35;36;37;38;39;40;$END$
 ;;41;42;43;45;46;47;48;49;50;51;52;53;54;55;56;57;58;$END$
 ;;59;61;62;63;64;65;66;67;69;70;71;72;73;74;75;76;77;$END$
 ;;78;79;80;81;82;83;84;85;86;87;88;89;90;91;92;93;94;$END$
 ;;95;96;97;98;99;100;101;102;103;104;105;106;107;108;$END$
 ;;109;110;111;112;113;114;115;116;117;118;119;120;121;$END$
 ;;122;123;124;125;126;127;128;131;133;134;135;136;138;$END$
 ;;139;141;142;143;146;147;148;149;150;152;154;155;156;$END$
 ;;157;158;159;160;162;163;165;166;168;170;171;172;173;$END$
 ;;174;175;176;177;178;233;252;309;320;335;359;360;361;$END$
 ;;376;441;442;443;445;446;462;469;471;474;537;549;561;$END$
 ;;569;570;571;572;573;574;575;576;577;578;579;580;581;$END$
 ;;582;583;584;585;586;587;588;589;590;591;592;593;594;$END$
 ;;595;596;597;598;599;600;601;602;603;604;605;606;607;$END$
 ;;608;611;614;617;629;630;631;632;636;638;641;644;645;$END$
 ;;646;680;684;685;686;687;688;689;690;691;692;693;694;$END$
 ;;695;696;697;698;699;700;701;702;703;704;705;706;707;$END$
 ;;708;709;710;711;712;713;714;715;716;717;718;725;732;$END$
 ;;$END$;;
 ;;
 ;;
LOOP N XUIEN,XUIEN2,XUEXDA,XUDIUSR,XUACTIVE,XUACONLY,%
 R !,"Do you want to list active users only? NO// ",%:20 Q:'$T
 S %=$TR($E(%),"YyNn","1100") I %="^" Q
 W !
 K ^TMP("XU8P377")
 S XUIEN=0 F  S XUIEN=$O(^VA(200,XUIEN)) Q:XUIEN'>0  D
 . I %=1,'(+$$ACTIVE^XUSER(XUIEN)) Q
 . S XUACTIVE=$P($$ACTIVE^XUSER(XUIEN),"^",2)
 . S XUDIUSR=XUACTIVE
 . D EN
 D PRNT
 Q
CHCK ;
 I '$D(^VA(200,XUIEN,"USC1","B",XUPCIEN)) Q
 S XUIEN2=$O(^VA(200,XUIEN,"USC1","B",XUPCIEN,"A"),-1)
 S XUEXDA=$P($G(^VA(200,XUIEN,"USC1",XUIEN2,0)),"^",3)
 I ('XUEXDA)!(XUEXDA>DT) D
 . S ^TMP("XU8P377",$J,XUPCIEN,XUIEN)=$P($G(^VA(200,XUIEN,0)),"^",1)_"^"_XUDIUSR
 . W "."
 Q
PRNT ;
 N XUI,XUY,XUV,XUCOUNT
 S XUI=0 F  S XUI=$O(^TMP("XU8P377",$J,XUI)) Q:XUI'>0  D
 . S XUV=$G(^USC(8932.1,XUI,0))
 . W !,"PERSON CLASS ID: ",XUI,?28,"    NAME: ",$E($P(XUV,"^",1),1,40)
 . W !,"        VA CODE: ",$P(XUV,"^",6),?28,"X12 CODE: ",$P(XUV,"^",7)
 . S XUCOUNT=0
 . W !!,"User Name",?34,"Status"
 . S XUY=0 F  S XUY=$O(^TMP("XU8P377",$J,XUI,XUY)) Q:XUY'>0  D
 . . W !,?2,$P($G(^TMP("XU8P377",$J,XUI,XUY)),"^"),?36,$P($G(^TMP("XU8P377",$J,XUI,XUY)),"^",2)
 . . S XUCOUNT=XUCOUNT+1
 . W !!,?10,"Number of users: ",XUCOUNT
 . W !,"------------------------------"
 D ^%ZISC
 Q
