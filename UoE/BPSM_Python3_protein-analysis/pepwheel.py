#!/usr/local/bin/python3
import os, subprocess
import pandas as pd
#Use any one of the sequences to draw the Helical wheel plot
#subprocess.call("pepwheel cag31453.1.fasta -gtitle Helical_Wheel -gsubtitle cag31453.1fasta -graph svg",shell=True)
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
  filename = name+'.fasta'
  command = r'pepwheel -sequence {0} -gtitle Helical_wheel -gsubtitle {0} -goutfile pepwheel_{0} -graph cps'.format(filename)
  subprocess.call(command, shell=True)
  
exit()




