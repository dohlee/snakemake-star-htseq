from pathlib import Path

RESULT_DIR = Path(config['result_dir'])

# Configurations for htseq_count
HC = config['htseq_count']
rule htseq_count:
    input:
        # Required input.
        alignment = RESULT_DIR /'01_star' / '{sample}.sorted.bam',
        annotation = config['reference']['gtf'],
    output:
        RESULT_DIR / '02_htseq_count' / '{sample}.htseq_count.result'
    threads: config['threads']['htseq_count']
    params:
        # Optional parameters. Read through the comments carefully.
        # Provide appropriate option for your data,
        # or comment out the option if it is not needed.
        extra = HC['extra'],
        # Sorting order of alignment file.
        # Option: 'pos' or 'name'
        # Default: name
        order = HC['order'],
        # When alignment file is paired end sorted by position, allow only
        # so many reads to stay in memory until the mates are found.
        # (raising this number will user more memory). Has no effect for
        # single end or paired end sorted by name.
        max_reads_in_buffer = HC['max_reads_in_buffer'],
        # Whether the data is from a strand-specific assay.
        # 'reverse' means 'yes' with reversed strand interpretation.
        # Option: 'yes', 'no', or 'reverse'
        # Default: yes
        stranded = HC['stranded'],
        # Skip all reads with alignment quality lower than the given
        # minimum value
        # Default: 10
        minaqual = HC['minaqual'],
        # Feature type (3rd column in GFF file) to be used, all
        # features of other type are ignored.
        # Default, suitable for Ensembl GTF files: exon
        type = HC['type'],
        # GFF attribute to be used as feature ID.
        # Default, suitable for Ensembl GTF files: gene_id
        idattr = HC['idattr'],
        # Additional feature attributes.
        # Use multiple times for each different attribute.
        # Default, none, suitable for Ensembl GTF files: gene_name
        additional_attr = HC['additional_attr'],
        # Mode to handle reads overlapping more than one feature.
        # Option: union, intersection-strict, intersection-nonempty
        # Default: union
        mode = HC['mode'],
        # Whether to score reads that are not uniquely aligned or ambiguously assigned
        # to features.
        # Option: none, all
        nonunique = HC['nonunique'],
        # Whether to score secondary alignments (0x100 flag)
        # Option: score, ignore
        secondary_alignments = HC['secondary_alignments'],
        # Whether to score supplementary alignments (0x800 flag)
        supplementary_alignments = HC['supplementary_alignments'],
        # Write out all SAM alignment records into SAM files (one per input file needed),
        # annotating each line with its feature assignment (as an optional field with tag 'XF')
        samout = HC['samout'],
        # Suppress progress report.
        quiet = HC['quiet'],
    log: 'logs/htseq/count/{sample}.log'
    benchmark: 'benchmarks/htseq/count/{sample}.log'
    wrapper:
        'http://dohlee-bio.info:9193/htseq/count'

