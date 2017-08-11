#!/bin/bash
#
# Copyright (c) 2017 Joji Doi
#
# Batch thumbnail generation script.
# Recursively search image files and generate thumbnails
# Usage: export TOP_DIR=/mnt/photos && bash thumbs-gen.bash

# log dir
if [ "${LOG_DIR}" == "" ]; then
  LOG_DIR=/tmp/$(date +%Y%m%d-%H%M%S)
fi
mkdir -p ${LOG_DIR}
LOG_FILE=${LOG_DIR}/thumbs-gen.log
echo "Thumbnail generation is started." > ${LOG_FILE}

# status file to notify UI when thumbs-gen is done
if [ "${OUTPUT_DIR}" == "" ]; then
  OUTPUT_DIR=/var/www/html/data
fi

# create a marker file. used by UI to decide when to load thumbs
echo '{"thumbs":"WIP"}' > ${OUTPUT_DIR}/thumb-gen.json
chmod 644 ${OUTPUT_DIR}/thumb-gen.json

# setup variables
if [ "${TOP_DIR}" == "" ]; then
  # support case-insensitive for `photos` dir
  TOP_DIR=/mnt
fi

# set thumbnail destination dir
THUMBS_DIR=${TOP_DIR}/.thumbs

# create thumbnail output dir in case it is absent
sudo mkdir -p ${THUMBS_DIR}

# backup Internal Field Separator variable
IFS_ORIG=${IFS}

# overwrite IFS variable to support filenames with white spaces
IFS=$(echo -en "\n\b")

# delete thumbnails that do not have original images
for fullname in $(find ${THUMBS_DIR} -type f -iname '*.png' -o -iname '*.jpg' -o -iname '*.tif' -o -iname '*.tiff' -o -iname '*.gif'); do
  #
  # Given thumbnail /mnt/.thumbs/mnt/photos/IMG_2147.JPG, target img will be in /mnt/photos/IMG_2147.JPG
  if [ ! -f ${fullname##${THUMBS_DIR}} ]; then
    echo "${fullname} thumbnail deleting..." >> ${LOG_FILE}
    sudo rm "${fullname}"
    echo "${fullname} thumbnail deleted." >> ${LOG_FILE}
  fi
done

# generate thumbnails if they do not exist
for fullname in $(find ${TOP_DIR}/* -maxdepth 8 -type f -iname '*.png' -o -iname '*.jpg' -o -iname '*.tif' -o -iname '*.tiff' -o -iname '*.gif'); do
  # note that this script skips hidden files with dot prefixed files
  #
  # Given /mnt/photos/IMG_2147.JPG as a fullname, thumbnail will be in /mnt/.thumbs/mnt/photos/IMG_2147.JPG
  if [ ! -f ${THUMBS_DIR}/${fullname} ]; then
    echo "${fullname} thumbnail creating..." >> ${LOG_FILE}
    targetdir=${THUMBS_DIR}/$(dirname "${fullname}")
    sudo mkdir -p "${targetdir}"
    sudo convert "${fullname}" -auto-orient -thumbnail 100x100 "${THUMBS_DIR}/${fullname}"
    echo "${fullname} thumbnail created." >> ${LOG_FILE}
  fi
done
echo "All thumbnail generation is completed." >> ${LOG_FILE}

# restore original IFS value
IFS=${IFS_ORIG}

# update a marker file
echo '{"thumbs":"DONE"}' > ${OUTPUT_DIR}/thumb-gen.json
