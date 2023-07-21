#!/usr/local/bin/python3
import os, subprocess
import pandas as pd
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
    subprocess.call(f"pepstats -sequence {name}.fasta {name}.pepstats",shell=True)
  
exit()

