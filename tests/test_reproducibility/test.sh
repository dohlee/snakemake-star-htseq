#!/bin/bash
set -e

# Test for reproducibility.
se_result="02_htseq_count/se/test_single.htseq_count.result"
se_result="02_htseq_count/se/test_paired.htseq_count.result"

snakemake -s startup.smk -p
snakemake -s ../../Snakefile --configfile config.yaml --config result_dir=result0 -pr -j2
snakemake -s ../../Snakefile --configfile config.yaml --config result_dir=result1 -pr -j2

se_a=$(md5sum result0/${se_result} | cut -d' ' -f1)
se_b=$(md5sum result1/${se_result} | cut -d' ' -f1)
pe_a=$(md5sum result0/${pe_result} | cut -d' ' -f1)
pe_b=$(md5sum result1/${pe_result} | cut -d' ' -f1)

if [ "$se_a" = "$se_b" ] && [ "pe_a" && "pe_b" ]; then
    curl https://gist.githubusercontent.com/dohlee/3ea154d52932b27d042566605a2cb9e2/raw/update_reproducibility.sh -H 'Cache-control: no-cache' | bash /dev/stdin -n
else
    curl https://gist.githubusercontent.com/dohlee/3ea154d52932b27d042566605a2cb9e2/raw/update_reproducibility.sh -H 'Cache-control: no-cache' | bash /dev/stdin -y
fi

echo "Test exited with $?."
