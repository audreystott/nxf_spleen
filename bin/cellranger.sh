#!/bin/bash

mkdir /data/references/GRCh38_2

mkdir /data/human/spleen/nxf_spleen/apps
cd /data/human/spleen/nxf_spleen/apps

wget -O cellranger-3.1.0.tar.gz "http://cf.10xgenomics.com/releases/cell-exp/cellranger-3.1.0.tar.gz?Expires=1574449980&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cDovL2NmLjEweGdlbm9taWNzLmNvbS9yZWxlYXNlcy9jZWxsLWV4cC9jZWxscmFuZ2VyLTMuMS4wLnRhci5neiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTU3NDQ0OTk4MH19fV19&Signature=TYH5zKhVnJqu03EJyhyn9UmfJ3VYkf2upYrYFgk0XzHa5C~DLi4567fblqTjizXjUZAjVxzwyT1-Q-SMQ0~8xILUxlSoVN-Yj0GM6YEkBpSzQCE8n9g~R4qVRx9I9TIjj3pOiKee-LW1f4Qa~7rZUYjTlLhKHVOyKyVoZVr4kaE-vHb-TKM5YNYoZzjHxavczoDyRbeKTGiPxj1bFSjJVLS0Ae19m4ZeG010EU0offGgEi3nDVd7s7ZX-k2UL4XDlzqbZuW2nj8U-ymvWFLv7rCQP8e8JiwUkr-kMFaqXchKgE7S0p4WndJHpg~roeFycXIoIH5JmLTkjPyZYNTQmg__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
tar -zxvf cellranger-3.1.0.tar.gz
        
cd cellranger-3.1.0

export PATH=/data/human/spleen/nxf_spleen/apps/cellranger-3.1.0:$PATH