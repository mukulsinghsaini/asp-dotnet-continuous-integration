Simple asp.net application continuous integration script
===================

>**Motivation:** Every firm has a different code/build management process. There can be no single solution. Available CI tools provide limited functionality. Batch script based automation provides the flexibility to easily adapt to requirement [(good read on CI)](https://www.thoughtworks.com/continuous-integration)

The script aims to serve as base on which CI process can be built.

The script performs the following tasks to automate app publishing to local filesystem:

 1. pulls latest code from SVN repo
 2. build the visual studio solutions
 3. publish the build to a staging area
 4. move the build to virtual directory
 5. publish a html web page with list of commit messages as release notes

----------



Setup
-------------
#### <i class="icon-file"></i> Pre requisite
Checkout the code you want to publish at a different location other than your dev code.This code base would never be modified to minimize code conflicts during updates.


#### <i class="icon-pencil"></i> Set variables
Modify the batch script **ci.cmd** according to your environment. 


```
SET svnCheckoutLocation="D:\code\project\dev"
SET svnRepoUrl="http://git-build:8080/svn/project/Dev" 
SET stagingLocation="D:\QA\project\stage"
SET publishLocation="\\ws-qa-server\project"
SET ideLocation="C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\"
SET frameworkLocation="C:\Windows\Microsoft.NET\Framework\v4.0.30319\"

SET solution1="D:\code\dev\projectLibrary\projectLibrary.sln"
SET solution2="D:\code\dev\projectUI\projectUI.sln"
SET uiProject="D:\code\dev\projectUI\projectUI\projectUI.csproj"
```
#### <i class="icon-pencil"></i>Creating build target

Open the UI csproj file and add the following code under ***Project*** node:
```
<Target Name="PublishToFileSystem" DependsOnTargets="PipelinePreDeployCopyAllFilesToOneFolder">
    <Error Condition="'$(PublishDestination)'==''" Text="The PublishDestination property must be set to the intended publishing destination." />
    <MakeDir Condition="!Exists($(PublishDestination))" Directories="$(PublishDestination)" />
    <ItemGroup>
      <PublishFiles Include="$(_PackageTempDir)\**\*.*" />
    </ItemGroup>
    <Copy SourceFiles="@(PublishFiles)" DestinationFiles="@(PublishFiles->'$(PublishDestination)\%(RecursiveDir)%(Filename)%(Extension)')" SkipUnchangedFiles="True" />
  </Target>
```

#### <i class="icon-pencil"></i> Embed auto generated release notes
The script copies a folder ***svnlogs*** to the published location.Add the following code to embed release notes into your application:
  
```
<a href="svnlogs\logs.html" target="_blank" >Release Notes</a>
```
  
#### <i class="icon-clock"></i> Scheduling the script

Schedule the script using windows task scheduler.Currently svn does not support event subscription, so set the frequency according to your requirements.

#### <i class="icon-pencil"></i> TODO

 - lots of scope for code optimization
 - test for VS2012 onwards
 - log errors
 - handle build failures

>***Tested On***
> - Visual Studio 2010
> - Tortoise SVN


