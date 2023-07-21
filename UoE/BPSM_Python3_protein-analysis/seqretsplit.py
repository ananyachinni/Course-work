#!/usr/local/bin/python3
import subprocess
#To split the multi sequence FASTA file into individual files
subprocess.call("seqretsplit -sequence pseq.fasta", shell = True)
