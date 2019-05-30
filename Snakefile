import pandas as pd
from pathlib import Path

configfile: 'config.yaml'

include: 'rules/star.smk'
include: 'rules/htseq-count.smk'

manifest = pd.read_csv(config['manifest'])
RESULT_DIR = Path(config['result_dir'])

SE_SAMPLES = manifest[manifest.library_layout == 'single'].name.values
PE_SAMPLES = manifest[manifest.library_layout == 'paired'].name.values

ALIGNED_BAM_SE = expand(str(RESULT_DIR / '01_star' / 'se' / '{sample}.sorted.bam'), sample=SE_SAMPLES)
ALIGNED_BAM_PE = expand(str(RESULT_DIR / '01_star' / 'pe' / '{sample}.sorted.bam'), sample=PE_SAMPLES)
EXPRESSIONS_SE = expand(str(RESULT_DIR / '02_htseq_count' / 'se' / '{sample}.htseq_count.result'), sample=SE_SAMPLES)
EXPRESSIONS_PE = expand(str(RESULT_DIR / '02_htseq_count' / 'pe' / '{sample}.htseq_count.result'), sample=PE_SAMPLES)

RESULT_FILES = []
RESULT_FILES.append(ALIGNED_BAM_SE)
RESULT_FILES.append(ALIGNED_BAM_PE)
RESULT_FILES.append(EXPRESSIONS_SE)
RESULT_FILES.append(EXPRESSIONS_PE)

rule all:
    input: RESULT_FILES
