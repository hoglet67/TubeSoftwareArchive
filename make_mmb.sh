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

for dir in `find original/6502 -type d | sort`
do

    # If the directory ends in _ then
    if [[ "${dir}" == *_ ]]
    then
        echo Packaging ${dir}
        # Package the contents of the directory as a file
        name=`basename ${dir}`
        # Remove the final _
        name=${name%?}
        # Replace any _ with space in title
        title=${name/_/ }
        get_disk_num
        ssd=${build}/${num}_${name}.ssd
        beeb blank_ssd ${ssd}
        beeb title ${ssd} ${title}
        beeb putfile ${ssd} ${dir}/*
        beeb info ${ssd}
    else
        # Scan the directory for ssd or dsd files
        for file in `find ${dir} -maxdepth 1 -name '*.[ds]sd' -type f | sort`
        do
            name=`basename ${file}`
            if [[ "${name}" == *.dsd ]]
            then
                echo Splitting ${file}
                get_disk_num
                side0=${build}/${num}_${name%.dsd}.ssd
                get_disk_num
                side2=${build}/${num}_${name%.dsd}.ssd
                beeb split_dsd ${file} ${side0} ${side2}
            else
                echo Copying ${file}
                get_disk_num
                cp ${file} ${build}/${num}_${name}
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
# Make smalled for testing
beeb dmerge_mmb -f BEEB.MMB ../not_in_git/BEEB.MMB TUBE.MMB
beeb dbase      -f BEEB.MMB 1
cd ..
