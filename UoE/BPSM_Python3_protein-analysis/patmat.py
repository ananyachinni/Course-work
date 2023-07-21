#!/usr/local/bin/python3
import os, subprocess
import pandas as pd
a = input('Do you want to continue? \n')
if a == "Y" or "yes" or "Yes":
   print ("Thank you!")
else:
   print ("Hmm, do not know what to do!")
print("Now, it's time for motif finding!")
dir_path = os.path.abspath(os.curdir)
#print(dir_path)
if __name__ == '__main__':
    with open('pseq.txt', 'r') as fr:
        reader = fr.readlines()
        res = []
        for line in reader:
            res.append(line.strip('\n').strip('\r'))
res_lower = list(pd.Series(res).str.lower())
for name in res_lower:
  with open(f"{name}.fasta") as seq: 
    subprocess.call(f"patmatmotifs ./{name}.fasta ./{name}.patmatmotifs",shell=True)
  
exit()
print("Let's check the motifs!")