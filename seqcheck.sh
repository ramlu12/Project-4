#!/bin/bash

file="$1"  # use the given file 
if [[ -f "$file" ]] # check if file exists
then
    printf "\nFile exists\n"
else
    printf "\nFile does not exist\n"
fi
if [[ $# -ne 1 ]] # check right number of arguments
then
    printf "\nWrong number of files. Provide one file only\n"
fi

n_loci="$(grep -E '[[:digit:]]+[[:space:]]+[[:digit:]]+' "$file" | wc -l)" # get total number of loci
for((i=1; i<=n_loci; i++)) # start loop
do
    current_header="$(grep -E '[[:digit:]]+[[:space:]]+[[:digit:]]+' "$file" | head -"$i" | tail -1)" # read header at each locus
    no_seq="$(echo "$current_header" | awk '{print $1}' | tr -d '$\r' )" # get seq number from header
    no_sites="$(echo "$current_header" | awk '{print $2}' | tr -d '$\r')" # get number of sites from header
    locus_start="$(grep "$current_header" "$file" | head -1)" 
    locus_end="$(grep -E '(\^[a-z0-9]+[[:space:]]+[a-zA-Z]+)+' "$file" | tail -1)"

    if [[ -z "locus_end" ]] # detects line break before start of next locus
    then current_locus="$(sed "$locus_start,$locus_end" "$file")" #
    fi

    count_seq="$(echo "$current_locus" | awk '{print $1}' | grep -E '\^[a-z0-9]+' | wc -l)"
    count_sites="$(echo "$current_locus" | awk '{print $2}' | head -2 | tail -1 | wc -c)"

    if [[ $no_seq -eq $count_seq ]] # check if observed seq is same as header
	    then printf "\nLocus %d: no_seq: %d matched and observed\n" "$i" "$count_seq"
	    else printf "\nLocus %d: no_seq: not matched; %d expected, %d observed\n" "$i" "$no_seq" "$count_seq"
	fi

	if [[ $no_sites -eq $count_sites ]] # check if observed sites is same as header
	    then printf "no_sites: %d matched and observed" "$count_sites"
	else printf "\nno_sites: not matched; %d expected, %d observed\n" "$no_sites" "$count_sites"
	fi
done


    

