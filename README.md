## Preface

I use these shell scripts to automate some basic tasks that are frequently occuring during setting up build environments or building android images on linux or OSX systems.

## Basic Installation + Configuration

The most basic configuration to use these scripts is to configure
the variable COMPILE_ROOT in *config.libsh* . 

It is preconfigured to use the directory "*˜/android/*" as compile root due to the fact that like the tutorial in [cyanogenmod wiki](http://wiki.cyanogenmod.com/wiki/Galaxy_Nexus_%28GSM%29:_Compile_CyanogenMod_9_%28Linux%29 "build tutorial nexus gsm cyanogenmod") most tutorials I have read use it as <COMPILE_ROOT> for the build.

if You are using the [google sources](http://source.android.com/source/initializing.html) You should place the WORKING_DIRECTORY below COMPILE_ROOT 



## Suggested File System Layout


	<COMPILE_ROOT>                                   - location containing Your builddirectory(s) 
     |
	 |_additional_apps                               - apps you want to include in Your build
	 | |_active                                      - dir containing symlinks to active packages
	 | | |_<PACKAGELINK> -> ../packages/<PACKAGEDIR> - symlink to package dir   
	 | | |_<SOURCELINK> -> ../packages/<SOURCEDIR>   - symlink to source
	 | | |_ …                                        - more symlinks to more packages 
	 | |                              
	 | |_packages                                    - dir containing all external packages                 
     | | |
	 | | |_<PACKAGEDIR>                              - Package apk
	 | | | |_Android.mk                              - see README
	 | | | |_<PACKAGE>.apk                           - package file
	 | | |_…                                         - more package dirs
	 | | 
	 | |_sources                                     - dir containing all external sources                          
	 |   |_<SOURCEDIR>                               - source repository                      
	 |   |_…                                         - more package dirs
	 |                         
	 |_bin                                           - dir containing these scripts
	 | |_logs                                        - default logs directoy
	 | | |_<SCRIPT>.log                              - script log (if logging is enabled)
	 | | |_...                                       - more script logs
	 | |_<SCRIPT>.sh                                 - script
	 | |_...                                         - more scripts
	 |               
	 |_system ( or system -> ./system_X )            - existing dir or symlink to your default build
	 |_system_X                                      - build 'X'
	 |_system_Y                                      - build 'Y' 
	 |_....                                          - more builds....
     |
     |_android_sdk                         - android sdk or symlink to it
       |_android-ndk                       - android ndk or symlink to it	
## Usage

### 

