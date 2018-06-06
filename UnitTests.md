Unit Tests for GT.M are called using ^ZOSVGUT1. There are three routines that
contain unit tests: ZOSVGUT1-3. They test every single change that
was made in this project.

This project also contains the "unredaction" of XUSHSH for Cache. The unit
tests to test that are in ZOSVONUT.

Test Setup: The tests need `stat` command, and need access to a writable `PRIMARY HFS
DIRECTORY`.

For GT.M, there are certain tests that may fail. You need to be aware of which ones:

 * TMTRAN - Make sure that Taskman is running. This fails occassionally because
 taskman is given 3 seconds to complete a task and sometimes can't complete it
 in that time.
 * ZSY - It counts processes before stopping them and after. If you didn't have
 any other processes running (i.e. Taskman was also down), you will get a failure
 here. Also, if you have an M process that is zsystemed out into the shell, you
 won't be able to kill it as well. Just keep that in mind.
 * RSAENC - RSA Encryption. This fails on certain versions of openssl. I haven't
 figured out yet which ones; but they ask you for a password when they shouldn't.
 If that happens to you, press CTRL-C, and then type ZC. Your text will be
 repeated, that's okay. To restore sanity, run ZSY "stty sane" when you are done.

The tests have been done on multiple versions of GT.M and YottaDB on Linux x64,
Darwin x64, Cygwin x32, and Arm7v.

Tests ran by `ZOSVGUT1`:
```
 ---------------------------------- ZOSVGUT1 ----------------------------------
SETNM - Set Environment Name----------------------------------  [OK]    0.080ms
ZRO1 - $ZROUTINES Parsing Single Object Multiple dirs.--------  [OK]    0.042ms
ZRO2 - $ZROUTINES Parsing 2 Single Object Single dir.---------  [OK]    0.016ms
ZRO3 - $ZROUTINES Parsing Shared Object/Code dir.-------------  [OK]    0.014ms
ZRO4 - $ZROUTINES Parsing Single Directory by itself.---------  [OK]    0.010ms
ZRO5 - $ZROUTINES Parsing Leading Space.----------------------  [OK]    0.012ms
ZRO7 - $ZROUTINES Shared Object Only.-------------------------  [OK]    0.011ms
ZRO8 - $ZROUTINES No shared object.---------------------------  [OK]    0.012ms
ZRO9 - $ZROUTINES Shared Object First.------------------------  [OK]    0.012ms
ZRO10 - $ZROUTINES Shared Object First but multiple rtn dirs.-  [OK]    0.013ms
ZRO99 - $$RTNDIR^%ZOSV Shouldn't be Empty.--------------------  [OK]    0.012ms
ACTJ - Default path through ACTJ^ZOSV.------------------------  [OK]    0.685ms
ACTJ0 - Force ^XUTL("XUSYS","CNT") to 0 to force algorithm to run...
 -------------------------------------------------------------  [OK]    0.060ms
AVJ - Available Jobs.-----------------------------------------  [OK]    0.039ms
DEVOK - Dev Okay..--------------------------------------------  [OK]    0.051ms
DEVOPN - Show open devices.-----------------------------------  [OK]    0.016ms
GETPEER - Get Peer.-------------------------------------------  [OK]    0.013ms
PRGMODE - Prog Mode

.-------------------------------------------------------------  [OK]    1.119ms
JOBPAR - Job Parameter -- Dummy; doesn't do anything useful..-  [OK]    0.063ms
LOGRSRC - Turn on Resource Logging----------------------------  [OK]    0.029ms
ORDER - Order.------------------------------------------------  [OK]    0.227ms
DOLRO - Ensure symbol table is saved correctly.---------------  [OK]    0.335ms
TMTRAN - Make sure that Taskman is running..------------------  [OK]  802.426ms
GETENV - Test GETENV.-----------------------------------------  [OK]    0.049ms
OS - OS.------------------------------------------------------  [OK]    0.023ms
VERSION - VERSION...------------------------------------------  [OK]    0.027ms
SID - System ID.----------------------------------------------  [OK]    0.042ms
UCI - Get UCI/Vol.--------------------------------------------  [OK]    0.042ms
UCICHECK - Noop.----------------------------------------------  [OK]    0.019ms
PARSIZ - PARSIZE NOOP.----------------------------------------  [OK]    0.018ms
NOLOG - NOLOG NOOP.-------------------------------------------  [OK]    0.015ms
SHARELIC - SHARELIC NOOP.-------------------------------------  [OK]    0.017ms
PRIORITY - PRIORITY NOOP.-------------------------------------  [OK]    0.016ms
PRIINQ - PRIINQ() NOOP.---------------------------------------  [OK]    0.015ms
BAUD - BAUD NOOP.---------------------------------------------  [OK]    0.015ms
SETTRM - Set Terminators.-------------------------------------  [OK]    0.101ms
LGR - Last Global Reference.----------------------------------  [OK]    0.045ms
EC - $$EC.----------------------------------------------------  [OK]    0.088ms
ZTMGRSET - ZTMGRSET Renames Routines on GT.M.-----------------  [OK]   11.536ms
ZHOROLOG - $ZHOROLOG Functions.....---------------------------  [OK]    0.023ms
TEMP - getting temp directory.--------------------------------  [OK]    0.076ms
PASS - PASTHRU and NOPASS.------------------------------------  [OK]    0.047ms
NSLOOKUP - Test DNS Utilities.......--------------------------  [OK]  116.777ms
IPV6 - Test GT.M support for IPV6.----------------------------  [OK]    0.061ms
SSVNJOB - Replacement for ^$JOB in XQ82..---------------------  [OK]   12.053ms
ZSY - Run System Status^[[54;1H^[[1;1H^[[J^[7^[[r^[[999;999H^[[6n^[8
GT.M System Status users on 23-APR-18 16:52:02 - (stats reflect accessing DEFAULT region ONLY except *)
^[[1mPID^[[m   ^[[1mPName^[[m   ^[[1mDevice^[[m       ^[[1mRoutine^[[m            ^[[1mName^[[m                ^[[1mCPU Time^[[m
29611 mumps   BG-0         IDLE+3^%ZTM        Taskman ROU 1       00:00:00
29668 mumps   BG-0         GO+26^XMKPLQ       WVEHR,PATCH INSTALLER00:00:00
29757 mumps   BG-0         GO+12^XMTDT        WVEHR,PATCH INSTALLER00:00:00
29791 mumps   BG-0         GETTASK+3^%ZTMS1                       00:00:00
29805 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 29805           00:00:00
29808 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 29808           00:00:00
29822 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 29822           00:00:00
29824 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 29824           00:00:00
29825 mumps   /dev/pts/2   INTRPTALL+8^ZSY    POSTMASTER          00:00:00

Total 9 users.

^[[16;1H^[[1;1H^[[J^[7^[[r^[[999;999H^[[6n^[8
GT.M System Status users on 23-APR-18 16:52:02 - (stats reflect accessing DEFAULT region ONLY except *)
^[[1mPID^[[m   ^[[1mPName^[[m   ^[[1mDevice^[[m       ^[[1mRoutine^[[m            ^[[1mName^[[m                ^[[1mCPU Time^[[m
29611 mumps   BG-0         IDLE+3^%ZTM        Taskman ROU 1       00:00:00
29668 mumps   BG-0         GO+26^XMKPLQ       WVEHR,PATCH INSTALLER00:00:00
29757 mumps   BG-0         GO+12^XMTDT        WVEHR,PATCH INSTALLER00:00:00
29791 mumps   BG-0         GETTASK+3^%ZTMS1                       00:00:00
29805 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 29805           00:00:00
29808 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 29808           00:00:00
29822 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 29822           00:00:00
29824 mumps   BG-0         GETTASK+3^%ZTMS1   Sub 29824           00:00:00
29825 mumps   /dev/pts/2   INTRPTALL+8^ZSY    POSTMASTER          00:00:00

Total 9 users.
..
Someone else is running the System status now.
EC+3^ZOSVGUT1,%YDB-E-DIVZERO, Attempt to divide by zero
$DEVICE=""
$ECODE=""
$ESTACK=7
$ETRAP="D ERROR^%ut"
$HOROLOG="64761,60723"
$IO="/dev/pts/2"
$JOB=29825
$KEY=$C(27)_"[74;283R"
$PRINCIPAL="/dev/pts/2"
$QUIT=0
$REFERENCE="^%ZOSF(""PROD"")"
$STACK=7
$STORAGE=2147483647
$SYSTEM="47,ibis"
$TEST=0
$TLEVEL=0
$TRESTART=0
$X=0
$Y=35
$ZA=0
$ZALLOCSTOR=3646378
$ZB=$C(27)_"[74;283R"
$ZCHSET="M"
$ZCLOSE=0
$ZCMDLINE=""
$ZCOMPILE=""
$ZCSTATUS=0
$ZDATEFORM=0
$ZDIRECTORY="/var/db/wv201602/"
$ZEDITOR=0
$ZEOF=0
$ZERROR="Unprocessed $ZERROR, see $ZSTATUS"
$ZGBLDIR="/var/db/wv201602/g/mumps.gld"
$ZHOROLOG="64761,60723,348074,14400"
$ZININTERRUPT=0
$ZINTERRUPT="I $$JOBEXAM^ZU($ZPOS)"
$ZIO="/dev/pts/2"
$ZJOB=29887
$ZKEY=""
$ZLEVEL=8
$ZMAXTPTIME=0
$ZMODE="INTERACTIVE"
$ZONLNRLBK=0
$ZPATNUMERIC="M"
$ZPOSITION="UERR+2^ZSY"
$ZPROCESS=""
$ZPROMPT="WV201602>"
$ZQUIT=0
$ZREALSTOR=3689914
$ZROUTINES="/var/db/wv201602//o*(/var/db/wv201602//r) /usr/local/lib/yottadb/r120//libgtmutil.so"
$ZSOURCE=""
$ZSTATUS="150373210,EC+3^ZOSVGUT1,%YDB-E-DIVZERO, Attempt to divide by zero"
$ZSTEP="n oldio s oldio=$i u 0 w $t(@$zpos),! b  u oldio"
$ZSTRPLLIM=0
$ZSYSTEM=0
$ZTNAME=""
$ZTDATA=0
$ZTDELIM=""
$ZTEXIT=""
$ZTLEVEL=0
$ZTOLDVAL=""
$ZTRAP=""
$ZTRIGGEROP=""
$ZTSLATE=""
$ZTUPDATE=""
$ZTVALUE=""
$ZTWORMHOLE=""
$ZUSEDSTOR=3646378
$ZUT=1524516723348088
$ZVERSION="GT.M V6.3-003A Linux x86_64"
$ZYERROR=""
$ZYRELEASE="YottaDB r1.20 Linux x86_64"
%="^%ZUA"
%D="%ZOSVKR^%ZOSVKSE^%ZOSVKSS^%ZOSVKSD"
%S="ZOSVKRG^ZOSVKSGE^ZOSVKSGS^ZOSVKSD"
%ZE=".m"
%ut=1
%ut("BREAK")=1
%ut("CHK")=62
%ut("CURR")=1
%ut("ECNT")=46
%ut("ELIN")=""
%ut("ENT")="ZSY^ZOSVGUT1"
%ut("ENTN")=47
%ut("ENUM")=0
%ut("ERRN")=0
%ut("FAIL")=0
%ut("IO")="/dev/pts/2"
%ut("LINE")=""
%ut("NAME")="Run System Status"
%ut("NENT")=0
%ut("SETUP")=""
%ut("TEARDOWN")=""
%utAnswer=2
%utBREAK=1
%utETRY(1)="SETNM"
%utETRY(1,"NAME")="Set Environment Name"
%utETRY(2)="ZRO1"
%utETRY(2,"NAME")="$ZROUTINES Parsing Single Object Multiple dirs"
%utETRY(3)="ZRO2"
%utETRY(3,"NAME")="$ZROUTINES Parsing 2 Single Object Single dir"
%utETRY(4)="ZRO3"
%utETRY(4,"NAME")="$ZROUTINES Parsing Shared Object/Code dir"
%utETRY(5)="ZRO4"
%utETRY(5,"NAME")="$ZROUTINES Parsing Single Directory by itself"
%utETRY(6)="ZRO5"
%utETRY(6,"NAME")="$ZROUTINES Parsing Leading Space"
%utETRY(7)="ZRO7"
%utETRY(7,"NAME")="$ZROUTINES Shared Object Only"
%utETRY(8)="ZRO8"
%utETRY(8,"NAME")="$ZROUTINES No shared object"
%utETRY(9)="ZRO9"
%utETRY(9,"NAME")="$ZROUTINES Shared Object First"
%utETRY(10)="ZRO10"
%utETRY(10,"NAME")="$ZROUTINES Shared Object First but multiple rtn dirs"
%utETRY(11)="ZRO99"
%utETRY(11,"NAME")="$$RTNDIR^%ZOSV Shouldn't be Empty"
%utETRY(12)="ACTJ"
%utETRY(12,"NAME")="Default path through ACTJ^ZOSV"
%utETRY(13)="ACTJ0"
%utETRY(13,"NAME")="Force ^XUTL(""XUSYS"",""CNT"") to 0 to force algorithm to run"
%utETRY(14)="AVJ"
%utETRY(14,"NAME")="Available Jobs"
%utETRY(15)="DEVOK"
%utETRY(15,"NAME")="Dev Okay"
%utETRY(16)="DEVOPN"
%utETRY(16,"NAME")="Show open devices"
%utETRY(17)="GETPEER"
%utETRY(17,"NAME")="Get Peer"
%utETRY(18)="PRGMODE"
%utETRY(18,"NAME")="Prog Mode"
%utETRY(19)="JOBPAR"
%utETRY(19,"NAME")="Job Parameter -- Dummy; doesn't do anything useful."
%utETRY(20)="LOGRSRC"
%utETRY(20,"NAME")="Turn on Resource Logging"
%utETRY(21)="ORDER"
%utETRY(21,"NAME")="Order"
%utETRY(22)="DOLRO"
%utETRY(22,"NAME")="Ensure symbol table is saved correctly"
%utETRY(23)="TMTRAN"
%utETRY(23,"NAME")="Make sure that Taskman is running"
%utETRY(24)="GETENV"
%utETRY(24,"NAME")="Test GETENV"
%utETRY(25)="OS"
%utETRY(25,"NAME")="OS"
%utETRY(26)="VERSION"
%utETRY(26,"NAME")="VERSION"
%utETRY(27)="SID"
%utETRY(27,"NAME")="System ID"
%utETRY(28)="UCI"
%utETRY(28,"NAME")="Get UCI/Vol"
%utETRY(29)="UCICHECK"
%utETRY(29,"NAME")="Noop"
%utETRY(30)="PARSIZ"
%utETRY(30,"NAME")="PARSIZE NOOP"
%utETRY(31)="NOLOG"
%utETRY(31,"NAME")="NOLOG NOOP"
%utETRY(32)="SHARELIC"
%utETRY(32,"NAME")="SHARELIC NOOP"
%utETRY(33)="PRIORITY"
%utETRY(33,"NAME")="PRIORITY NOOP"
%utETRY(34)="PRIINQ"
%utETRY(34,"NAME")="PRIINQ() NOOP"
%utETRY(35)="BAUD"
%utETRY(35,"NAME")="BAUD NOOP"
%utETRY(36)="SETTRM"
%utETRY(36,"NAME")="Set Terminators"
%utETRY(37)="LGR"
%utETRY(37,"NAME")="Last Global Reference"
%utETRY(38)="EC"
%utETRY(38,"NAME")="$$EC"
%utETRY(39)="ZTMGRSET"
%utETRY(39,"NAME")="ZTMGRSET Renames Routines on GT.M"
%utETRY(40)="ZHOROLOG"
%utETRY(40,"NAME")="$ZHOROLOG Functions"
%utETRY(41)="TEMP"
%utETRY(41,"NAME")="getting temp directory"
%utETRY(42)="PASS"
%utETRY(42,"NAME")="PASTHRU and NOPASS"
%utETRY(43)="NSLOOKUP"
%utETRY(43,"NAME")="Test DNS Utilities"
%utETRY(44)="IPV6"
%utETRY(44,"NAME")="Test GT.M support for IPV6"
%utETRY(45)="SSVNJOB"
%utETRY(45,"NAME")="Replacement for ^$JOB in XQ82"
%utETRY(46)="ZSY"
%utETRY(46,"NAME")="Run System Status"
%utETRY(47)="HALTONE"
%utETRY(47,"NAME")="Test HALTONE^ZSY entry point"
%utI=46
%utIO="/dev/pts/2"
%utLIST=3
%utONLY=0
%utRNAM="ZOSVGUT1"
%utROU(1)="ZOSVGUT1"
%utROU(2)="ZOSVGUT2"
%utROU(3)="ZOSVGUT3"
%utROU1=""
%utStart="64761,60722,86255,14400"
%utVERB=3
CURRROU="ZOSVGUT1"
DILOCKTM=3
DISYS=19
DT=3180423
DTIME=300
DUZ=.5
DUZ(0)=""
DUZ(1)=""
DUZ(2)=1
DUZ("AG")="E"
DUZ("LANG")=""
I=4
IO="/dev/null"
IO(0)="/dev/pts/2"
IO(1,"/dev/null")=""
IO("CLOSE")="/dev/null"
IO("ERROR")=""
IO("HOME")="50^/dev/pts/2"
IOBS="$C(8)"
IOF="#"
IOHG=""
IOM=0
ION="NULL"
IOPAR=""
IOS=47
IOSL=64
IOST="P-OTHER"
IOST(0)=16
IOT="TRM"
IOUPAR=""
IOXY=""
J=1
POP=0
U="^"
X=""
XMDUN="POSTMASTER"
XMDUZ=.5
XMV("ASK BSKT")=1
XMV("DUZ NAME")="POSTMASTER"
XMV("MSG DEF")="D"
XMV("NAME")="POSTMASTER"
XMV("NETNAME")="POSTMASTER@BETA.VISTA-OFFICE.ORG"
XMV("NEW OPT")="R"
XMV("NEW ORDER")=1
XMV("NOSEND")=0
XMV("ORDER")=1
XMV("PREVU")=0
XMV("RDR ASK")="Y"
XMV("RDR DEF")="C"
XMV("SHOW DUZ")=0
XMV("SHOW INST")=0
XMV("SHOW TITL")=0
XMV("VERSION")="VA MailMan 8.0"
XUVOL="ROU"
Y="VAH^ROU^ibis^ROU:ibis"
Z1=24789
Z2="TASKS^14.4^24786"
ZE="150373210,EC+3^ZOSVGUT1,%YDB-E-DIVZERO, Attempt to divide by zero"
cnt=0
ctrap=""
d=1
d(1)="/var/db/wv201602/r/"
delim=" "
exc=""
from=" !""#$&'()+'-./;<=>@[]\^_`{}|~"_$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,127)
k=2
last=$C(255)
nProcs=9
nProcsAfter=1
out=1
r=""
r(0)=$C(255)
rd=0
scwc="?"
to=""
/dev/null OPEN 
/dev/pts/2 OPEN TERMINAL NOPAST NOREADS TYPE NOWRAP WIDTH=255 LENG=74 FIL=ESCAPES 
MLG:11,MLT:0
GLD:*,REG:*,SET:620,KIL:316,GET:374,DTA:208,ORD:364,ZPR:0,QRY:0,LKS:11,LKF:0,CTN:0,DRD:1169,DWT:3,NTW:663,NTR:1244,NBW:678,NBR:4789,NR0:16,NR1:8,NR2:6,NR3:0,TTW:0,TTR:0,TRB:0,TBW:0,TBR:0,TR0:0,TR1:0,TR2:0,TR3:0,TR4:0,TC0:0,TC1:0,TC2:0,TC3:0,TC4:0,ZTR:0,DF
L:0,DFS:0,JFL:0,JFS:0,JBB:12056,JFB:8192,JFW:2,JRL:42,JRP:4,JRE:0,JRI:0,JRO:1,JEX:0,DEX:0,CAT:681,CFE:0,CFS:34158574,CFT:32704,CQS:0,CQT:0,CYS:1928,CYT:232,BTD:7
GLD:/usr/local/lib/yottadb/r120/gtmhelp.gld,REG:DEFAULT,SET:0,KIL:0,GET:0,DTA:0,ORD:0,ZPR:0,QRY:0,LKS:0,LKF:0,CTN:0,DRD:0,DWT:0,NTW:0,NTR:0,NBW:0,NBR:0,NR0:0,NR1:0,NR2:0,NR3:0,TTW:0,TTR:0,TRB:0,TBW:0,TBR:0,TR0:0,TR1:0,TR2:0,TR3:0,TR4:0,TC0:0,TC1:0,TC2:0,T
C3:0,TC4:0,ZTR:0,DFL:0,DFS:0,JFL:0,JFS:0,JBB:0,JFB:0,JFW:0,JRL:0,JRP:0,JRE:0,JRI:0,JRO:0,JEX:0,DEX:0,CAT:0,CFE:0,CFS:0,CFT:0,CQS:0,CQT:0,CYS:0,CYT:0,BTD:0
GLD:/var/db/wv201602/g/mumps.gld,REG:DEFAULT,SET:42,KIL:12,GET:181,DTA:67,ORD:32,ZPR:0,QRY:0,LKS:9,LKF:0,CTN:2080043593,DRD:0,DWT:3,NTW:42,NTR:308,NBW:37,NBR:844,NR0:0,NR1:0,NR2:0,NR3:0,TTW:0,TTR:0,TRB:0,TBW:0,TBR:0,TR0:0,TR1:0,TR2:0,TR3:0,TR4:0,TC0:0,TC1
:0,TC2:0,TC3:0,TC4:0,ZTR:0,DFL:0,DFS:0,JFL:0,JFS:0,JBB:12056,JFB:8192,JFW:2,JRL:42,JRP:4,JRE:0,JRI:0,JRO:1,JEX:0,DEX:0,CAT:42,CFE:0,CFS:0,CFT:0,CQS:0,CQT:0,CYS:0,CYT:0,BTD:7
GLD:/var/db/wv201602/g/mumps.gld,REG:TEMPGBL,SET:578,KIL:304,GET:193,DTA:141,ORD:332,ZPR:0,QRY:0,LKS:2,LKF:0,CTN:16485243,DRD:1169,DWT:0,NTW:621,NTR:936,NBW:641,NBR:3945,NR0:16,NR1:8,NR2:6,NR3:0,TTW:0,TTR:0,TRB:0,TBW:0,TBR:0,TR0:0,TR1:0,TR2:0,TR3:0,TR4:0,
TC0:0,TC1:0,TC2:0,TC3:0,TC4:0,ZTR:0,DFL:0,DFS:0,JFL:0,JFS:0,JBB:0,JFB:0,JFW:0,JRL:0,JRP:0,JRE:0,JRI:0,JRO:0,JEX:0,DEX:0,CAT:639,CFE:0,CFS:34158574,CFT:32704,CQS:0,CQT:0,CYS:1928,CYT:232,BTD:0
UERR+2^ZSY:68a3cbbaee3ef37a3e3ea95fa4f6457f
ZSY+15^ZOSVGUT1:d03d68bc3f117fcb47498b2b673cf5e5
EN1+80^%ut
EN1+56^%ut:da33a4f234061011ea7c8622e7e3c475
EN1+27^%ut:da33a4f234061011ea7c8622e7e3c475
EN+9^%ut:da33a4f234061011ea7c8622e7e3c475
ZOSVGUT1+8^ZOSVGUT1:d03d68bc3f117fcb47498b2b673cf5e5
+1^GTM$DMOD    (Direct mode) 
.^[[16;1H^[[1;1H^[[J--------------------------------------------------------------  [OK] 1262.572ms
HALTONE - Test HALTONE^ZSY entry point..----------------------  [OK]  260.787ms

 ---------------------------------- ZOSVGUT2 ----------------------------------
NOOP - Top doesn't do anything..------------------------------  [OK]    0.171ms
SAVE1 - Save a Routine normal......---------------------------  [OK]    1.203ms
SAVE2 - Save a Routine with syntax errors -- should not show..  [OK]   16.995ms
LOAD - Load Routine..-----------------------------------------  [OK]    1.764ms
RSUM - Checksums..--------------------------------------------  [OK]    0.336ms
TESTR - Test existence of routine.----------------------------  [OK]    0.145ms
DELSUPER - Test Super Duper Deleter..-------------------------  [OK]   11.395ms
XUSHSH - Top of XUSHSH.---------------------------------------  [OK]    0.074ms
SHA - SHA-1 and SHA-256 in Hex and Base64....-----------------  [OK]   65.942ms
BASE64 - Base 64 Encode and Decode..--------------------------  [OK]    2.235ms
RSAENC - Test RSA Encryption........--------------------------  [OK]  186.930ms
AESENC - Test AES Encryption.---------------------------------  [OK]    6.889ms
BROKER - Test the new GT.M MTL Broker.....
--------------------------------------------------------------  [OK]  704.814ms
ACTJPEEK - Active Jobs using $$^%PEEKBYNAME("node_local.ref_cnt",...).
 -------------------------------------------------------------  [OK]    0.272ms
ACTJREG - Active Jobs using current API.----------------------  [OK]    0.147ms

 ---------------------------------- ZOSVGUT3 ----------------------------------
OPENH - Read a Text File in w/ Handle
..------------------------------------------------------------  [OK]    8.115ms
OPENNOH - Read a Text File w/o a Handle
..------------------------------------------------------------  [OK]    2.559ms
OPENBLOR - Read a File as a binary device (FIXED WIDTH)
..------------------------------------------------------------  [OK]    0.351ms
OPENBLOW - Write a File as a binary device (Use Capri zip file in 316.18)
.-------------------------------------------------------------  [OK]    0.632ms
OPENBLOV - Write and Read a variable record file
.-------------------------------------------------------------  [OK]    4.041ms
OPENDF - Open File from Default HFS Directory.--------------------------------------------------------------  [OK]    0.125ms
OPENSUB - Open file with a Specific Subtype....--------------------------------------------------------------  [OK]    3.076ms
OPENDLM - Forget delimiter in Path..--------------------------------------------------------------  [OK]    2.440ms
OPENAPP - Open with appending.-------------------------------------------------------------  [OK]    2.344ms
PWD - Get Current Working Directory.--------------------------  [OK]    0.037ms
DEFDIR - Default Directory.....-------------------------------  [OK]    0.295ms
LIST - LIST^%ZISH.....----------------------------------------  [OK]  126.042ms
MV - MV^%ZISH..-------------------------------------------------------------  [OK]    2.567ms
FTGGTF - $$FTG^%ZISH & $$GTF^%ZISH......-------------------------------------------------------------  [OK]    5.934ms
GATF - $$GATF^%ZISH......-----------------------------------------------------------  [OK]    2.640ms
DEL1 - DEL1^%ZISH......---------------------------------------  [OK]    1.950ms
DEL - Delete files we created in the tests.....---------------  [OK]    6.586ms
DELERR - Delete Error.----------------------------------------  [OK]    0.093ms
OPENRPMS - Test RPMS OPEN^%ZISH (3 arg open)....-------------------------------------------------------------  [OK]    3.099ms
DELRPMS - Test RPMS DEL^%ZISH (reverse success, pass by value)....----------------------------------------------------------  [OK]    4.455ms
LISTRPMS - Test LIST RPMS Version (2nd par is by value not by name).....
 -------------------------------------------------------------  [OK]  122.862ms
SIZE - $$SIZE^%ZISH.------------------------------------------  [OK]    1.792ms
MKDIR - $$MKDIR^%ZISH...--------------------------------------  [OK]    6.987ms
WGETSYNC - $$WGETSYNC^%ZISH on NDF DAT files......------------  [OK] 5658.496ms
SEND - Test SEND^%ZISH (NOOP).--------------------------------  [OK]    0.034ms
SENDTO1 - Test SENDTO1^%ZISH (NOOP).--------------------------  [OK]    0.010ms
DF - Test DF^%ZISH (Directory Format).------------------------  [OK]    0.012ms

Ran 3 Routines, 89 Entry Tags
Checked 182 tests, with 0 failures and encountered 0 errors.
```

Tests ran by ZOSVONUT:
```
>d ^ZOSVONUT

 ---------------------------------- ZOSVONUT ----------------------------------
XUSHSH - Top of XUSHSH.---------------------------------------  [OK]    0.051ms
SHA - SHA-1 and SHA-256 in Hex and Base64....-----------------  [OK]    1.147ms
BASE64 - Base 64 Encode and Decode..--------------------------  [OK]    0.030ms
RSAENC - Test RSA Encryption........--------------------------  [OK] 3038.698ms
AESENC - Test AES Encryption.---------------------------------  [OK]    0.086ms
SIZE - $$SIZE^%ZISH.------------------------------------------  [OK]   63.093ms
MKDIR - $$MKDIR^%ZISH for Unix--------------------------------  [OK]    0.024ms
MDWIN - $$MKDIR^%ZISH for Windows..---------------------------  [OK]  128.696ms
WGETSYNC - $$WGETSYNC^%ZISH on NDF DAT files for Unix and Windows......
 -------------------------------------------------------------  [OK] 9498.746ms
