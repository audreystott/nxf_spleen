#!/bin/bash

read -p "Cell Ranger download URL: " crURL 
echo $crURL > cellranger_url.txt

read -p "bcl2fastq2 download URL: " bcl2URL
echo $bcl2URL > bcl2fastq2_url.txt