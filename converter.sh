#!/usr/bin/env bash

# make a temp directory and work from there 
tmpdir=$(mktemp -d)
echo "working directory: $tmpdir"
cp -r ./* "$tmpdir" && cd "$tmpdir"

# destination of new files
destination="/mnt/c/Users/odior/Documents/new_pdfs"

IFS=$'\n' files_array=($(find . -type f))
unset IFS

for html_file in "${files_array[@]}"; do
	echo "processing file ${html_file}"
	
	# Remove nav bar from file, also remove dark theme(it should be the first theme in file)	
	sed -i '/<nav/,/<\/nav>/d' "${html_file}"; 
	sed -i 's/dark/white/' "${html_file}"; 
	
	echo "ready to print pdf for file ${html_file}"
	google-chrome --headless --print-to-pdf="${html_file##*/}.pdf" "${html_file}"
done

# create the destination directory
if [ ! -d "$destination" ]; then
	mkdir -p "$destination" 
done

#copy created files to destination
cp . "$destination"	

# clean up tmp directory
rm -rf "$tmpdir"
