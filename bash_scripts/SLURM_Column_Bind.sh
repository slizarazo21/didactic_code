#!/bin/bash
# ----------------SLURM Parameters----------------
#SBATCH -p normal
#SBATCH -n 1
#SBATCH --mem=10g
#SBATCH -N 1

DIR='Your_Directory'

DIR2='Your_Directory2'

cd "$DIR"

### Extracting a parameter. For more information you can look to Regex. In this case in my personal folder there
### are files named as follow 'bins_Tissue_#_Chr#.tab'

### This gives me a list of all the Tissues present in my directory
pairs=$(ls *.tab | grep -oP 'bins_\K[^_]+(?=_.+)' | sort | uniq)

### This gives me a list of all he Chromosomes present in my directory
chrom=$(ls *.tab | grep -oP 'chr[0-9X]+' | sort | uniq)

### Loop, I want to concatenate all the files in my directory and group them into a single file
### per tissue per chromosome

for tiss in $pairs; do

echo "Working now on "$tiss""
echo "++++++++++++++++++++++++++++++++++++++++++++++"

        for chr in $chrom; do
        
        echo "Working now on "$chr""
		echo "     "
		echo "     "

        ### This is just meant to filter files per specific chromosome
        files=($(ls bins_${tiss}_*.tab))
        kk=""$chr"_"
        files2=($(echo "${files[@]}" | tr ' ' '\n' | grep -P "$kk"))

        echo "list of files for this chromosome"
        echo ${files2[@]}
        echo "     "
        echo "number of files"
        echo ${#files2[@]}
        echo "     "
        
        first="${files2[0]}"
        
        echo "This is the first file"
        echo $first
        echo "     "
        ### Renaming the files
        cp "$first" "${tiss}_${chr}_temp.tab"

        #### This is the loop for concatenation. Starting from the 2nd file, I am using file 1 as template to add columns
       for ((i = 1; i < ${#files2[@]}; i++)); do
    	file="${files2[$i]}"
     ### This is the concatenation step!
     ## It takes the file and adds thhe <(...)> prompt wich helps with adding an extra function within the function

     ## In this case it is cbinding all the columns after the 4 column.
     
    	paste "${tiss}_${chr}_temp.tab" <(cut -f4- "$file") > "${tiss}_${chr}_temp2.tab"
   		mv "${tiss}_${chr}_temp2.tab" "${tiss}_${chr}_temp.tab"
		done	

        ### Moves the file to the new directory.
         mv "${tiss}_${chr}_temp.tab" "${DIR2}/${tiss}_${chr}.tab"
     
     	echo "Printing col names"
        head -n 1 "${DIR2}/${tiss}_${chr}.tab"
        
        echo "++++++++++++++++++++++++++++++++++++++++++++++"

  
  done
echo "++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++++++++++++++++++++++++++++++++++++++++++"    
echo "STARTING A NEW TISSUE"    
echo "++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++++++++++++++++++++++++++++++++++++++++++"
echo "++++++++++++++++++++++++++++++++++++++++++++++"    
done
