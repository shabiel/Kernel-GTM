%ZOSVKSD ; OSE/SMH - ZOSVKSD - Calculate Disk Capacity ;2018-07-19
 ;;8.0;KERNEL;**10003**;3/1/2018
 ;
 ; This routine will help to calculate disk capacity for
 ; GT.M system platforms for each region.
 ;
EN(SITENUM,SESSNUM,OS) ;-- called by routine SYS+2^KMPSLK
 ;--------------------------------------------------------------------
 ; SITENUM = Station number of site
 ; SESSNUM = SAGG session number
 ; VOLS    = Array containing names of monitored volumes
 ; OS      = Type of M platform (CVMS, CWINNT)
 ;
 ; Returns ^XTMP("KMPS",SITENUM,SESSNUM,"@VOL",vol_name) = vol_size
 ;--------------------------------------------------------------------
 ;
 Q:'$G(SITENUM)
 Q:$G(SESSNUM)=""
 Q:$G(OS)=""
 ;
 n region s region=""
 f  s region=$view("gvnext",region) q:region=""  do
 . s ^XTMP("KMPS",SITENUM,SESSNUM,"@VOL",region)=$view("totalblocks",region)
 ;
 QUIT
 ;
KMPVVSTM(KMPVDATA) ; Get storage metrics for Vista Storage Monitor (VSTM) within VistA System Monitor (VSM)
 N KMPVRNS,KMPVTNS,KMPVDIR,KMPVDB,KMPVMAX,KMPVSIZE,KMPVBSIZ,KMPVBPM,KMPVSTAT,KMPVFMB
 N KMPVFBLK,KMPVSYSD,KMPVESIZ,KMPVFLAG,KMPVRSET,KMPVDFSP
 S U="^"
 ; get current namespace, switch to %SYS
 ;
 n region s region=""
 for  set region=$view("gvnext",region) q:region=""  do
 .;
 .; KMPVBPM - Blocks per map: n/a for GTM.
 .; KMPVSYSD - Is this a system directory: %SYS in Cache; n/a for GT.M
 .n blockSize s blockSize=$$^%PEEKBYNAME("sgmnt_data.blk_size",region)
 .n totalBlocks s totalBlocks=$view("totalblocks",region)
 .n freeBlocks s freeBlocks=$view("freeblocks",region)
 .n usedBlocks s usedBlocks=totalBlocks-freeBlocks
 .n blockSizeMB s blockSizeMB=blockSize/1024/1024
 .S KMPVMAX=totalBlocks*blockSizeMB
 .S KMPVSIZE=usedBlocks*blockSizeMB
 .S KMPVBSIZ=blockSize,KMPVBPM="n/a"
 .S KMPVFMB=freeBlocks*blockSizeMB,KMPVFBLK=freeBlocks
 .S KMPVSYSD="n/a",KMPVESIZ=$$^%PEEKBYNAME("sgmnt_data.extension_size",region)*blockSizeMB
 .S KMPVDF=$$RETURN^%ZOSV("df -m "_$view("gvfile",region)_" | awk '{ if (NR!=1) {print $4} }'")
 .; MaxSize(MB)^Current Size(MB)^Block Size(int)^Blocks per Map(int)^Free space(MB)^
 .; Free Space(int-Blocks)^System Dir(bool)^Expansion size^disk free space (MB)
 .S KMPVDATA(region)=$J(KMPVMAX,"",2)_U_$J(KMPVSIZE,"",2)_U_KMPVBSIZ_U_KMPVBPM_U_$J(KMPVFMB,"",2)_U_KMPVFBLK_U_KMPVSYSD_U_KMPVESIZ_U_KMPVDF
 Q
