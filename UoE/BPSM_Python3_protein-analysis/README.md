# BPSM Assignment - Protein sequences analysis

This sub-repository contains scripts performing Bioinformatics analysis on protein sequences based on user input.

## Workflow:
<img src="https://github.com/ananyachinni/Course-work/assets/78129588/3e6e8487-46fb-40cf-9202-5bdc8ddbc790"
width=75% height=50%>

### User manual:
1. This program workflow begins with getting user input about the species and protein family for obtaining the protein sequences. _Entrez_ utilities like Esearch and efetch are
   used to get the sequences and accession numbers (getting_sequences.py).
3. The sequences file is used to perform multiple sequence alignment using _clustalo_ (multi_seq.py).
4. The msf file obtained from the previous step, is used to generate a conservation plot using EMBOSS plotcon (plotcon.py).
5. The seqretsplit.py program splits the multi-FASTA file into individual FASTA files.
6. Next, the sequences are used to elucidate protein statistics and motifs.
   * Statistical properties of the proteins are estimated using the EMBOSS pepstats tool (pepstats.py).
   * To find motifs in the sequence, EMBOSS patmatmotifs tool was used. The tool finds motifs in the sequence based on the **PROSITE** database (patmat.py)[^1].
7. The properties of the proteins were also defined in this workflow[^1].
   * The degree of hydrophobicity and hydrophilicity of the protein were identified using the EMBOSS pepwindow tool. Hydropathy plots were also generated (hydropathy_plot.py).
   * Additionally, helical wheel diagrams were also generated to define the proteins' characteristics using EMBOSS pepwheel (pepwheel.py).
[^1]: These tools take only one protein sequence as input, so that's why the multi-FASTA file was split.

