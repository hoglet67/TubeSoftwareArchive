#!/bin/bash

build=build

mkdir -p ${build}

rm -f ${build}/*

# Recurse directory structure

n=0

function get_disk_num {
    printf -v num "%03d" $n
    n=$((n+1))
}

# $1 is the path to the .ssd file
# if this ends in _.ssd then mangle the title

function update_title {
    file=$1
    name=$2
    if [[ "$name" == *_ ]]
    then
        # Remove the trailin _
        title=${name%_}
        # Replace any _ with spaces in title
        title=${title//_/ }
        # Set the title
        beeb title "$file" "${title}"
        # Rename the file to remove the _
        mv "$file" "${file%_.ssd}.ssd"
    fi
}

for dir in `find original/6502 -type d | sort`
do

    # If the directory ends in _ then
    if [[ "${dir}" == *_ ]]
    then
        echo Packaging ${dir}
        # Package the contents of the directory as a file
        name=`basename ${dir}`
        get_disk_num
        ssd=${build}/${num}_${name}.ssd
        beeb blank_ssd ${ssd}
        beeb putfile ${ssd} ${dir}/*
        beeb info ${ssd}
        update_title ${ssd} ${name}
    else
        # Scan the directory for ssd or dsd files
        for file in `find ${dir} -maxdepth 1 -name '*.[ds]sd' -type f | sort`
        do
            name=`basename ${file}`
            if [[ "${name}" == *.dsd ]]
            then
                echo Splitting ${file}
                name=${name%.dsd}
                get_disk_num
                side0=${build}/${num}_${name}.ssd
                get_disk_num
                side2=${build}/${num}_${name}.ssd
                beeb split_dsd ${file} ${side0} ${side2}
                update_title "${side0}" "${name}"
                update_title "${side2}" "${name}"
            else
                echo Copying ${file}
                name=${name%.ssd}
                get_disk_num
                ssd=${build}/${num}_${name}.ssd
                cp "${file}" "${ssd}"
                update_title "${ssd}" "${name}"
            fi
        done
    fi
done

find build | sort
# Build a MMB file

cd build
beeb dblank_mmb -f TUBE.MMB
for ssd in `find . -type f -name '*.ssd' | cut -c3- | sort`
do
    num=${ssd:0:3}
    beeb dput_ssd -f TUBE.MMB ${num} ${ssd}
done

beeb dcat -f TUBE.MMB

beeb dmerge_mmb -f BEEB.MMB ../not_in_git/BEEB.MMB TUBE.MMB
beeb dbase      -f BEEB.MMB 1

if [[ -f /media/dmb/MMFS/BEEB.MMB ]]
then
    echo "Copying to SD Card"
    cp BEEB.MMB /media/dmb/MMFS/BEEB.MMB
fi

cd ..
