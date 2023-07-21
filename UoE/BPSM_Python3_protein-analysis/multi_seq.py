#!/usr/local/bin/python3
import os
import subprocess
sequence=open("pseq.fasta")
#Doing multiple sequence alignment
subprocess.call("clustalo -i pseq.fasta --outfmt msf -o pseq.msf -v",shell=True)
sequence.close()
print("Multiple sequence alignment done.")
