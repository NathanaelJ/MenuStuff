use AppleScript version "2.4"
use scripting additions
use framework "Foundation"
use framework "AppKit"

property StatusItem : missing value
property selectedMenu : "" -- each menu action will set this to a number, this will determine which IP is shown
global notifytime
global content

property theDisplay : ""
property defaults : class "NSUserDefaults"

-- check we are running in foreground - YOU MUST RUN AS APPLICATION. to be thread safe and not crash
if not (current application's NSThread's isMainThread()) as boolean then
	display alert "This script must be run from the main thread." buttons {"Cancel"} as critical
	error number -128
end if

-- create an NSStatusBar
on makeStatusBar()
	set bar to current application's NSStatusBar's systemStatusBar
	
	set StatusItem to bar's statusItemWithLength:-1.0
	
	-- set up the initial NSStatusBars title
	StatusItem's setTitle:"IP"
	set newMenu to current application's NSMenu's alloc()'s initWithTitle:"Custom"
	set internalMenuItem to current application's NSMenuItem's alloc()'s initWithTitle:"Local IP" action:"showInternal:" keyEquivalent:""
	set externalMenuItem to current application's NSMenuItem's alloc()'s initWithTitle:"Public IP" action:"showIExternal:" keyEquivalent:""
	set noteMenuItem to current application's NSMenuItem's alloc()'s initWithTitle:"Note" action:"createnote:" keyEquivalent:""
	set maxMenuItem to current application's NSMenuItem's alloc()'s initWithTitle:"Stress Test" action:"stressIt:" keyEquivalent:""
	set gooseItem to current application's NSMenuItem's alloc()'s initWithTitle:"Goose" action:"goose:" keyEquivalent:""
	set hjonkItem to current application's NSMenuItem's alloc()'s initWithTitle:"Hjönk" action:"hjonk:" keyEquivalent:""
	set memeItem to current application's NSMenuItem's alloc()'s initWithTitle:"Speak" action:"speak:" keyEquivalent:""
	set quitgooseItem to current application's NSMenuItem's alloc()'s initWithTitle:"Kill Goose" action:"quitgoose:" keyEquivalent:""
	set quitter to current application's NSMenuItem's alloc()'s initWithTitle:"Quit" action:"quitter" keyEquivalent:"q"
	
	StatusItem's setMenu:newMenu
	newMenu's addItem:internalMenuItem
	newMenu's addItem:externalMenuItem
	newMenu's addItem:(current application's NSMenuItem's separatorItem)
	newMenu's addItem:noteMenuItem
	newMenu's addItem:maxMenuItem
	newMenu's addItem:(current application's NSMenuItem's separatorItem)
	newMenu's addItem:gooseItem
	newMenu's addItem:hjonkItem
	newMenu's addItem:memeItem
	newMenu's addItem:quitgooseItem
	newMenu's addItem:(current application's NSMenuItem's separatorItem)
	newMenu's addItem:quitter
	internalMenuItem's setTarget:me
	externalMenuItem's setTarget:me
	noteMenuItem's setTarget:me
	maxMenuItem's setTarget:me
	gooseItem's setTarget:me
	hjonkItem's setTarget:me
	memeItem's setTarget:me
	quitgooseItem's setTarget:me
	quitter's setTarget:me
end makeStatusBar

--Show Internal ip Action
on showInternal:sender
	
	
	defaults's setObject:"1" forKey:"selectedMenu"
	my runTheCode()
end showInternal:

--Show External ip Action
on showIExternal:sender
	
	
	defaults's setObject:"2" forKey:"selectedMenu"
	my runTheCode()
end showIExternal:

--Show note
on createnote:none
	
	set content to display dialog "" with title "Write a note" default answer "" buttons {"Set & Remind", "Set"} default button "Set"
	
	if button returned of content is "Set & Remind" then
		set notifytime to display alert "Reminder Time" message "minutes" buttons {"1", "5", "60"} default button "5"
		display notification "Reminding every " & (button returned of notifytime) & " minutes" sound name "blow" with title (text returned of content)
	end if
	
	defaults's setObject:"3" forKey:"selectedMenu"
	my displayIP(text returned of content)
end createnote:

--Stress test
on stressIt:none
	
	set killTime to display alert "Test Duration" message "Time in seconds" buttons {"5", "15", "60"} default button "15"
	
	StatusItem's setTitle:"Stressing out"
	
	set pid1 to do shell script "yes" & " &> /dev/null & echo $!"
	set pid2 to do shell script "yes" & " &> /dev/null & echo $!"
	set pid3 to do shell script "yes" & " &> /dev/null & echo $!"
	set pid4 to do shell script "yes" & " &> /dev/null & echo $!"
	set pid5 to do shell script "yes" & " &> /dev/null & echo $!"
	set pid6 to do shell script "yes" & " &> /dev/null & echo $!"
	set pid7 to do shell script "yes" & " &> /dev/null & echo $!"
	set pid8 to do shell script "yes" & " &> /dev/null & echo $!"
	set pid9 to do shell script "yes" & " &> /dev/null & echo $!"
	set pid10 to do shell script "yes" & " &> /dev/null & echo $!"
	set pid11 to do shell script "yes" & " &> /dev/null & echo $!"
	
	delay (button returned of killTime)
	
	do shell script "killall yes"
	
	my runTheCode()
	
end stressIt:

--Goose actions
on goose:none
	tell application "Desktop Goose" to activate
end goose:

on hjonk:none
	tell application "Desktop Goose" to honk
end hjonk:

on quitgoose:none
	tell application "Desktop Goose" to quit
end quitgoose:

on speak:none
	tell application "Desktop Goose" to collect note
end speak:

--Quit
on quitter()
	continue quit
end quitter

-- update statusBar
on displayIP(theDisplay)
	StatusItem's setTitle:theDisplay
end displayIP

on runTheCode()
	
	set stringAddress to ""
	--use NSHost to get the Internal IP address 
	set inIPAddresses to current application's NSHost's currentHost's addresses
	
	--work through each item to find the IP
	repeat with i from 1 to number of items in inIPAddresses
		set anAddress to (current application's NSString's stringWithString:(item i of inIPAddresses))
		set ipCheck to (anAddress's componentsSeparatedByString:".")
		set the Counter to (count of ipCheck)
		
		if (anAddress as string) does not start with "127" then
			if Counter is equal to 4 then
				set stringAddress to anAddress
				-- found a match lets exit the repeat
				exit repeat
			end if
		else
			set stringAddress to "Not available"
		end if
	end repeat
	
	-- Get extenal IP
	
	set anError to missing value
	set iPURL to (current application's NSURL's URLWithString:"http://ipecho.net/plain")
	
	set NSUTF8StringEncoding to 4
	set exIP to (current application's NSString's stringWithContentsOfURL:iPURL encoding:NSUTF8StringEncoding |error|:anError) as string
	if exIP contains missing value then
		set exIP to "Not available"
	end if
	
	set selectedMenu to (defaults's stringForKey:"selectedMenu") as string
	if selectedMenu is "" or selectedMenu contains missing value then
		set selectedMenu to "1"
	end if
	
	if selectedMenu is "1" then
		set theDisplay to stringAddress
		my displayIP(theDisplay)
	else if selectedMenu is "2" then
		set theDisplay to exIP
		my displayIP(theDisplay)
	else if selectedMenu is "3" then
		try
			if button returned of notifytime is "1" then
				display notification text returned of content sound name "blow" with title "Note to self"
			else if button returned of notifytime is "5" then
				delay 240
				display notification text returned of content sound name "blow" with title "Note to self"
			else if button returned of notifytime is "60" then
				delay 3540
				display notification text returned of content sound name "blow" with title "Note to self"
			end if
		on error
			set selectedMenu to "1"
		end try
	end if
	
	--call to update statusBar
	--Moved inside loop to prevent note from disappearing
	
end runTheCode

--repeat run  update code
on idle
	
	my runTheCode()
	--my displayIP(theDisplay)
	
	return 60 -- run every 60 seconds
	
end idle
-- call to create initial NSStatusBar
set defaults to current application's NSUserDefaults's standardUserDefaults
my makeStatusBar()
