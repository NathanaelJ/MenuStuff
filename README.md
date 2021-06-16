# MenuStuff

Small but useful tools living in your MacOS menu bar

Now with [desktop goose!](https://samperson.itch.io/desktop-goose)

![Screenshot](https://github.com/NathanaelJ/MenuStuff/blob/main/Options.png)

## Installation

You'll need to install desktop goose first!
1. Clone this repository, and open the script using script editor (installed with MacOS).
2. Use file > export and save as an application.
3. Run the application! It's useful to setup 'open at login'

^ I'm fairly confident this isn't the most efficient way to install this, but it works for me.

## Use

* **Local IP** displays your local IP address
* **Public IP** displays your public IP address
* **Note** lets you write a note to display in the menu bar, with the option to set a reminder notification
* **Stress test** runs a CPU stress test on your mac, by launching 22 instances* of the 'yes' shell command, for a specified period of time
* **Goose** Launches desktop goose
* **Hjonk** Makes desktop goose honk
* **Speak** Makes desktop goose pull out a message
* **Kill goose** Kill (quit) desktop goose

*22 Instances have been tested on a 6-core iMac, although these may not be enough for more powerful devices. The number of instances can be changed manually in AppleScript

## Issues & acknowledgements

No currently known issues. Please let me know if you spot any!

This code is an adaptation of code written by 'markhunte' on [Stack Overflow](https://stackoverflow.com/questions/29191190/display-and-update-applescript-output-in-background)
