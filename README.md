VistA/RPMS Kernel Enhancements Project
======================================
Enhancements to the VistA Kernel for GT.M and Cache. Originally, this project
focused only on GT.M, but due to redaction and omissions in VA code, various
Cache routines have been enhanced, like ZISHONT and ZOSVONT.

Products & Installation
-----------------------
Patch XU\*8.0\*10001 & XU\*8.0\*10002 can be found in releases. Full release
notes can be found there.

You can install these either using a KIDS build by unzipping the routines in
the virgin_install.zip. You should always use the KIDS build unless you have
a new system that you are building that doesn't have KIDS operational yet. In
that case, you should unzip the files in virgin_install.zip into your routines
directory.

The KIDS builds provided are combined: BOTH XU\*8.0\*10001 and XU\*8.0\*10002
are in a sequential KIDS build.

Download links:
 * KIDS: https://github.com/shabiel/Kernel-GTM/releases/download/XU-8.0-10002/XU_8-0_10001--XU_8-0_10002.KID
 * .m files for virgin installations: https://github.com/shabiel/Kernel-GTM/releases/download/XU-8.0-10002/virgin_install.zip

Unit Testing
------------
See [UnitTests.md](UnitTests.md)

Future Plans
------------
I plan to port the following packages in these order:
 
 * RPMS %ZISH (done)
 * Job Examination capability for ZSY (done)
 * XOBW web service implementation for GT.M (done)
 * Resource Usage Monitor (RUM)
 * Statistical Analysis of Global Growth (SAGG)
