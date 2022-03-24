#!/bin/bash

# /etc/cpmtools/diskdefs need the following entry:
#
# diskdef acorn
#   seclen 512
#   tracks 160
#   sectrk 5
#   blocksize 2048
#   maxdir 128
#   skew 0,2,4,1,3
#   boottrk 3
#   os 2.2
# end

mkdir -p disks
cd files
for i in `find . -type d | cut -c3- | sort`
do
    echo Making $i.dsd
    cp blank.img tmp.img
    cpmcp -f acorn tmp.img $i/* 0:
    java -jar ../../../../tools/cpmutils.jar S2A tmp.img ../disks/$i.dsd
    rm -f tmp.img
done
cd ..
ls -l disks
