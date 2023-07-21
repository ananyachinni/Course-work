#!/usr/local/bin/python3
import subprocess
print("Let's do some plotting...")
subprocess.call("plotcon -sformat msf pseq1.msf -sprotein1 True -graph svg", shell=True)
print("Please check the image!")
