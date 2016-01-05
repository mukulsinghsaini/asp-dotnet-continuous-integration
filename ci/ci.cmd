@ECHO OFF
SETLOCAL ENABLEEXTENSIONS EnableDelayedExpansion
SET me=%~n0
SET parent=%~dp0

ECHO Running %me% ...

::##################################
SET svnCheckoutLocation="D:\code\project\dev"
SET svnRepoUrl="http://svn-build:8080/svn/project/Dev" 
SET stagingLocation="D:\QA\project\stage"
SET publishLocation="\\ws-qa-server\project"
SET ideLocation="C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\"
SET frameworkLocation="C:\Windows\Microsoft.NET\Framework\v4.0.30319\"

SET solution1="D:\code\dev\projectLibrary\projectLibrary.sln"
SET solution2="D:\code\dev\projectUI\projectUI.sln"
SET uiProject="D:\code\dev\projectUI\projectUI\projectUI.csproj"
::##################################

ECHO # Checking if any new changes in code

IF NOT EXIST out\LatestRevision.txt (
		svn info !svnRepoUrl! | grep "Revision:" | tr -dc '0-9' > out\LatestRevision.txt
		SET /P lastKnownRev=<out\LatestRevision.txt
		SET /P latestRev=<out\LatestRevision.txt
		ECHO 	LastKnownRevision: -
		ECHO 	LatestRevision: !latestRev!
		SET /A changesFound=1
) ELSE (
		SET /P lastKnownRev=<out\LatestRevision.txt
		svn info !svnRepoUrl! | grep "Revision:" | tr -dc '0-9' > out\LatestRevision.txt
		SET /P latestRev=<out\LatestRevision.txt
		ECHO 	LastKnownRevision: !lastKnownRev!
		ECHO 	LatestRevision: !latestRev!
		
		IF !lastKnownRev! EQU !latestRev! (
			SET /A changesFound=0
		) ELSE (
			SET /A changesFound=1
		)
)

powershell get-date -format "{dd-MMM-yyyy HH:mm tt}" >> out\cilogs.txt
ECHO LastKnownRevision: !lastKnownRev! LatestRevision: !latestRev! changesFound: !changesFound! >> out\cilogs.txt

IF !changesFound!==0 (
	ECHO # No new changes found
	ECHO # COMPLETE !
	EXIT /B 0
)


ECHO # updating svn
svn update !svnCheckoutLocation! > nul

IF NOT EXIST "out\svnlogs.txt" (
		svn log !svnRepoUrl! --xml --incremental > out\svnlogs.xml
) ELSE (
		svn log !svnRepoUrl! -r !lastKnownRev!:!latestRev! --xml --incremental > out\svnlogsdelta.xml
		copy /B out\svnlogsdelta.xml + out\svnlogs.xml out\temp.xml >nul
		move /Y out\temp.xml out\svnlogs.xml >nul
)

powershell get-date -format "{dd-MMM-yyyy HH:mm tt}" > out\updatedon.txt

copy /B helper\rootopen.txt + out\svnlogs.xml + helper\rootclose.txt out\svnlogswithroot.xml >nul

ECHO # generating logs web page

helper\msxsl.exe out\svnlogswithroot.xml helper\logsToHtml.xsl -o ui\logs.html >nul

ECHO # building application

!ideLocation!devenv.exe !solution1! /rebuild Debug >nul

!ideLocation!devenv.exe !solution2! /rebuild Debug >nul

ECHO # publishing application

cd /d !frameworkLocation!

msbuild !uiProject! ^
/p:Configuration=Release ^
/p:Platform=AnyCPU ^
/t:PublishToFileSystem  ^
/p:DeleteExistingFiles=True ^
/p:PublishDestination=!stagingLocation! >nul


ECHO # moving build to QA server
robocopy  !stagingLocation! !publishLocation! /mir >nul
robocopy !parent!ui !publishLocation!\svnlogs >nul
copy !parent!out\updatedon.txt !publishLocation!\svnlogs\ >nul
ECHO # COMPLETE !

EXIT /B 0



