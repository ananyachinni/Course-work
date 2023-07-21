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
    #filename = name+'.fasta'
    #command = r'pepwindow -sequence {0} -gtitle Hydropathy_plot -gsubtitle {0} -goutfile pepwindow_{0} -graph cps'.format(filename)
    #subprocess.call(command, shell=True)
  with open(f"{name}.fasta") as seq: 
    subprocess.call(f"pepwindow {name}.fasta -gtitle Hydropathy_plot -gsubtitle {name}.fasta -gxtitle Protein_Sequence -gytitle Hydropathy -goutfile pepwindow_{name} -graph svg",shell=True)
  

