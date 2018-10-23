/*
	Title :	The Ring Package Manager 
	Date  : 2018.10.17
	Author: Mahmoud Fayed <msfclipper@yahoo.com>
*/

# Load Global Libraries 
	load "stdlibcore.ring"
	load "internetlib.ring"		# Download() Function

# Load Local Libraries 
	load "consolecolors.ring"
	load "cuilib/cuilib.ring"

# Load Application Files 
	load "core/globals.ring"
	load "core/console.ring"
	load "core/getpara.ring"
	load "core/commands.ring"
	load "core/version.ring"
	load "core/folders.ring"
	load "core/packages.ring"

func Main 
	aCommand = GetParameters("ringpm")
	oAllPackagesInfo.LoadInfo()
	cDir = CurrentDir()
	Title()
	Commands()	
	ExecuteCommands()
	chdir(cDir)
	oAllPackagesInfo.SaveInfo()