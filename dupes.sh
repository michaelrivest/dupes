#!/bin/bash
IFS=$'\n'
SEARCH_DIR=$1
printf "Searching %s for Dupes\n" ${SEARCH_DIR:='./'}
TOTAL_DUPE_SIZE=0

LST_D_FNAME=nada
LST_D_INODE=nada
LST_D_SIZE=7

for i in $(find "$SEARCH_DIR" -type f -printf "%s:%i:%p\n" | sort); do 
    
    IFS=":" read -r CUR_SIZE CUR_INODE CUR_FNAME <<< "$i"

    if [ "$LST_D_SIZE" -eq "$CUR_SIZE" ]
        then
          CUR_SUM=$(md5sum "$CUR_FNAME" | cut -d ' ' -f 1)
          LST_D_SUM=$(md5sum "$LST_D_FNAME" | cut -d ' ' -f 1)

          if [ "$LST_D_SUM" = "$CUR_SUM" ] && [ "$CUR_INODE" != "$LST_D_INODE" ]
            then
                printf "Dupe:\t%-40s\n" $CUR_FNAME 
                TOTAL_DUPE_SIZE=$(( $TOTAL_DUPE_SIZE + $CUR_SIZE ))
          fi
    fi

    LST_D_INODE=$CUR_INODE
    LST_D_SIZE=$CUR_SIZE
    LST_D_FNAME=$CUR_FNAME
done
printf "Total Dupe Size: %d\n" $TOTAL_DUPE_SIZE
exit
