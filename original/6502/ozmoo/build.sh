#!/bin/bash

# Manually download games from Itch and extract Z5 files to games/
#
#    Hibernated
#        https://8bitgames.itch.io/hibernated1
#        ===> games/hibernated1_r12.z5
#
#    The Job
#        https://fredrikr.itch.io/the-job
#        ===> games/thejob_R5.z5

#########################################################
# Download OZMOO
#########################################################

OZMOO=stardot-ozmoo-preview-9.21-alpha-43
if [ ! -d ozmoo ]
then
    wget -O ozmoo.zip https://github.com/ZornsLemma/ozmoo/archive/refs/tags/$OZMOO.zip
    unzip ozmoo.zip
    rm -f ozmoo.zip
    mv ozmoo-$OZMOO ozmoo
fi


#########################################################
# Download Games
#########################################################

if [ ! -d downloads ]
then
    mkdir -p downloads
    cd downloads
    # Alien Research Centre 3 and Behind Closed Doors 9 were posted to stardot
    wget -O balrog.zip https://stardot.org.uk/forums/download/file.php?id=60993
    unzip balrog.zip
    rm -f balrog.zip
    # Calypso was poster to stardot
    wget -O calypso.zip https://stardot.org.uk/forums/download/file.php?id=59155
    unzip calypso.zip
    rm -f calypso.zip
    # Classic Adventure
    wget https://raw.githubusercontent.com/sugarlabs/Frotz/master/Advent.z5
    # Infocom
    wget https://eblong.com/infocom/gamefiles/beyondzork-r60-s880610.z5
    wget https://eblong.com/infocom/gamefiles/hitchhiker-invclues-r31-s871119.z5
    wget https://eblong.com/infocom/gamefiles/hollywoodhijinx-r37-s861215.z3
    wget https://eblong.com/infocom/gamefiles/leathergoddesses-invclues-r4-s880405.z5
    wget https://eblong.com/infocom/gamefiles/planetfall-invclues-r10-s880531.z5
    wget https://eblong.com/infocom/gamefiles/wishbringer-invclues-r23-s880706.z5
    wget https://eblong.com/infocom/gamefiles/zork1-invclues-r52-s871125.z5
    wget https://eblong.com/infocom/gamefiles/zork2-r48-s840904.z3
    wget https://eblong.com/infocom/gamefiles/zork3-r17-s840727.z3
    cd ..
fi

#########################################################
# Build Games
#########################################################

OPTIONS=-p

cd ozmoo

echo Building Adventure...
python make-acorn.py $OPTIONS --title "Adventure" ../downloads/Advent.z5 ../disks/Adventure_.ssd

echo Building Alien Research Centre 3...
python make-acorn.py $OPTIONS --title "Alien Research Centre 3" ../downloads/arc3d.z3 ../disks/ARC_3_.ssd

echo Building Behind Closed Doors 9...
python make-acorn.py $OPTIONS --title "Behind Closed Doors 9" ../downloads/bcd9b.z3 ../disks/BCD_9_.ssd

echo Building Beyond Zork...
python make-acorn.py $OPTIONS --title "Beyond Zork" ../downloads/beyondzork-r60-s880610.z5 ../disks/Beyond_Zork_.dsd

echo Building Calypso...
python make-acorn.py $OPTIONS --title "Calypso" ../downloads/calypso.z5 ../disks/Calypso_.ssd

if [ -f ../games/hibernated1_r12.z5 ]
then
    echo Building Hibernated 1 - Directors Cut...
    python make-acorn.py --splash-image ../games/hibernated-splash-mode2 --splash-mode 2 $OPTIONS --title "Hibernated 1 - Directors Cut" ../games/hibernated1_r12.z5 ../disks/Hibernated_1_.ssd
else
    echo Skipping Hibernated 1 - Directors Cut...
fi

echo Building The Hitchhikers Guide to the Galaxy...
python make-acorn.py $OPTIONS --title "The Hitchhikers Guide to the Galaxy" ../downloads/hitchhiker-invclues-r31-s871119.z5 ../disks/HitchHiker_.dsd

echo Building Hollywood Hijinx...
python make-acorn.py $OPTIONS --title "Hollywood Hijinx" ../downloads/hollywoodhijinx-r37-s861215.z3 ../disks/Hollywood_.ssd

if [ -f ../games/thejob_R5.z5 ]
then
    echo Building The Job R5...
    python make-acorn.py $OPTIONS --title "The Job R5" ../games/thejob_R5.z5 ../disks/The_Job_R5.ssd
else
    echo Skipping The Job R5...
fi

echo Building Leather Goddesses of Phobos...
python make-acorn.py $OPTIONS --title "Leather Goddesses of Phobos" ../downloads/leathergoddesses-invclues-r4-s880405.z5 ../disks/Leather_.dsd

echo Building Planetfall...
python make-acorn.py $OPTIONS --title "Planetfall" ../downloads/planetfall-invclues-r10-s880531.z5 ../disks/Planetfall_.ssd

echo Building Wishbringer...
python make-acorn.py $OPTIONS --title "Wishbringer" ../downloads/wishbringer-invclues-r23-s880706.z5 ../disks/Wishbringer_.dsd

echo Building Zork1: The Great Underground Empire...
python make-acorn.py $OPTIONS --title "Zork1: The Great Underground Empire" ../downloads/zork1-invclues-r52-s871125.z5 ../disks/Zork1_.ssd

echo Building Zork2: The Wizard of Frobozz...
python make-acorn.py $OPTIONS --title "Zork2: The Wizard of Frobozz" ../downloads/zork2-r48-s840904.z3 ../disks/Zork2_.ssd

echo Building Zork3: The Dungeon Master...
python make-acorn.py $OPTIONS --title "Zork3: The Dungeon Master" ../downloads/zork3-r17-s840727.z3 ../disks/Zork3_.ssd

#########################################################
# Cleanup
#########################################################

rm -f temp/*
