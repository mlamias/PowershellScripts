# 1. Unzip the files to a folder
# 2. Open a command prompt as Administrator (right click on Command Prompt shortcut icon)
# or search for it:

WINDOWS KEY + (S)earch
type "command" in search field
	^ right-click the Command Prompt icon, select "Run as administrator"

# 3. Once inside the command prompt, type "powershell" and press enter.
# Note: This will move you into PS mode.

# 4. Once in PS mode, type
powershell -ExecutionPolicy Unrestricted
# Note: This will give you the rights to run both ps1 scripts with no errors.

# 5. Type this to run COMPUTE script
powershell -noexit 'C:\Users\UserName\Path` to` Script\AMD-Compute-n-Stability-Script\compute.ps1'
# or type this to run STABILITY script
powershell -noexit 'C:\Users\UserName\Path` to` Script\AMD-Compute-n-Stability-Script\stability.ps1'

# Note: You can see I added a ` before each space in the path. You will need to
# add a ` before every space in your path for this to work. PowerShell cannot
# have spaces in a path. e.g.

# wrong way to define a path with spaces in folder name
powershell -noexit 'C:\Users\John\Appleseed\my folder spaces\downloads\script.ps1'

# correct way to define a path with spaces in folder name
powershell -noexit 'C:\Users\John\Appleseed\my` folder` spaces\downloads\script.ps1'

# 6. Follow the easy instructions from the scripts :)