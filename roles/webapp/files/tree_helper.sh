#!/bin/bash

cd /mnt && tree --noreport -J | jq .[0].contents > /var/www/html/data/media_files_list_v3.json
