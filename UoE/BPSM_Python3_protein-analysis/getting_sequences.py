#!/usr/local/bin/python3
#Importing modules
import os
import sys
import string
import subprocess
#Getting user input on Species and Protein family to search for
taxonomic_group=input("What is the taxonomic group you are looking for?\n\t")
groups=["Aves","aves", "Vertebrates","vertebrates", "Mammals","mammals", "Rodents","rodents"]
if taxonomic_group in groups:
    print("Great choice of animals!")
else:
    print("Try again!")
protein_fam=input("What is the protein family you would like to analyse?\n\t")
families=["glucose-6-phosphatase","Glucose-6-phosphatase", "ABC transporters","abc transporters","adenyl cyclases","Adenyl cyclases","Kinases","kinases"]
if protein_fam in families:
   print("Thanks for the protein family!")
else:
   print("Please try again!")
#We're ready to download the sequences and accession numbers
print("Sequences and accession numbers are downloading, please wait.......\n")
subprocess.call("esearch -db protein -query '{} AND {}'|efetch -format fasta > pseq.fasta".format(protein_fam,taxonomic_group),shell=True)
subprocess.call("esearch -db protein -query '{} AND {}'|efetch -format acc > pseq.txt".format(protein_fam,taxonomic_group),shell=True)
