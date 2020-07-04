#!/usr/bin/env nextflow

/*
========================================================================================
                                vAMPirusv0.1.0
========================================================================================
                       Virus Amplicon Sequencing Analysis Pipeline
                       Author: Alex J. Veglia
                       Version: 0.1.0 (dev) LAST EDIT: 5/30/20
----------------------------------------------------------------------------------------
*/

def helpMessage() {
    log.info """
    ==============================================================================================================================================================================================
                                                                         Quick help, use --fullHelp for usage examples
    ==============================================================================================================================================================================================

        Steps:
            1- Run the `precheck_TransPi.sh` to install tools, set up the databases and directories for

            2- Run vAMPirusv0.1.0.sh

            Usage:

                nextflow run vAMPirusv0.1.0.sh

        Help options:

                --help                          Print help information

                --fullHelp                      Print even more help information

        Mandatory arguments (choose one):

                --Analyze                       Run absolutely everything

                --dataCheck                     Assess how data performs with during processing and clustering

                --generateAAcounts              Provide vAMPirus with a translated fasta file and the merged reads you would like mapped and it will generate a protein counts file for you

                --generateReport                Provide vAMPirus with paths to necessary files to generate a vAMPirus report

        Clustering arguments:

                --nOTU                          Set this option to have vAMPirus cluster nucleotide amplicon sequence variants (ASVs) into nucleotide-based operational taxonomic units (nOTUs) - See options below to define a single percent similarity or a list

                --pOTU                          Set this option to have vAMPirus cluster nucleotide and translated ASVs into protein-based operational taxonomic units (pOTUs) - See options below to define a single percent similarity or a list

        Skip arguments:

                --skipReadProcessing            Set this option to skip all read processing steps in the pipeline

                --skipFastQC                    Set this option to skiip FastQC steps in the pipeline

                --skipAdapterRemoval            Set this option to skip adapter removal in the pipeline

                --skipPrimerRemoval             Set this option to skup Skip primer removal process

                --skipAminoTyping               Set this option to skip AminoTyping processes

                --skipTaxonomy                  Set this option to skip taxonomy assignment processes

                --skipPhylogeny                 Set this option to skip phylogeny processes

        Analysis-specific options (will override information in the config file):

            General information

                --projtag                       Set project name to be used as a prefix for output files

                --metadata                      Set path to metadata spreadsheet file to be used for report generation (must be defined if generating report)

                --mypwd                         Path to working directory that contains (i) the vAMPirus.nf script, (ii) the nextflow.config, and (iii) directory containing read libraries

                --email                         Your email for notifications for when jobs are submitted and completed

                --reads                         Path to directory containing read libraries, must have *R{1,2}.fast{a,q} in the name

                --outdir                        Name of directory to store output of vAMPirus run

        Merged read length filtering options

                --minLen                        Minimum merged read length - reads below the specified maximum read length will be used for counts only

                --maxLen                        Maximum merged read length - reads with length equal to the specified max read length will be used to identifying unique sequences and  subsequent Amplicon Sequence Variant (ASV) analysis

                --maxEE                         Use this option to set the maximum expected error rate for vsearch merging. Default is 1.

        Primer Removal options

                --GlobTrim                      Set this option to perform global trimming to reads to remove primer sequences  #,#

                --fwd                           Specify forward primer sequence pecific primer sequence on forward reads to be removed

                --rev                           Reverse primer sequence

        Amplicon analysis options

                --alpha                         Alpha value for denoising - the higher the alpha the higher the chance of false positives in ASV generation (1 or 2)

                --minSize                       Minimum size or representation for sequence to be considered in ASV generation

                --clusterNuclID                 With --nOTU set, use this option to set a single percent similarity to cluster nucleotide sequences into OTUs by [ Example: --clusterNuclID .97 ]

                --clusterNuclIDlist             With --nOTU set, use this option to perform nucleotide clustering with a comma separated list of percent similarities [ Example: --clusterNuclIDlist .95,.96,.97,.98 ]

                --clusterAAID                   With --pOTU set, use this option to set a single percent similarity for amino acid-based OTU clustering [ Example: --clusterAAID .97 ]

                --clusterAAIDlist               With --pOTU set, use this option to perform amino acid-based OTU clustering with a comma separated list of percent similarities [ Example: --clusterAAIDlist .95,.96,.97,.98 ]

                --minAA                         With --pOTU set, use this option to set the expected or minimum amino acid sequence length of open reading frames within your amplicon sequences


        Counts table options

                --asvcountID                    Similarity ID to use for ASV counts

                --ProtCountID                   Minimum amino acid sequence similarity for hit to count

                --ProtCountsLength              Minimum alignment length for hit to count


        Taxonomy assignment parameters

                --dbname                       Specify name of database to use for analysis

                --dbdir                        Path to Directory where database is being stored

                --refseq                       Toggle use of RefSeq header format; default is Reverence Viral DataBase (RVDB)

                --Bitscore                     Set minimum bitscore for Diamond command

                --

        Phylogeny analysis parameters

                --ntmodeltrax                 Use this option to use the nucleotide model of substitution determined by ModelTest-NG

                --ptmodeltrax                 Use this option to use the amino acid model of substitution determined by ModelTest-NG

        Paths to files needed for --generateAAcounts option

                --proteinFasta                 Path to protein sequence fasta file to be used for counts

                --mergedFast                   Path to merged read fastq/fasta file to be used for counts

                --sampleList                   Path to list of sample names which are mentioned in the sequence headers

        |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    """.stripIndent()
}
def fullHelpMessage() {
    log.info """
    ==============================================================================================================================================================================================
                                                        THIS IS A LONGER HELP WITH USAGE EXAMPLES vAMPirus
    ==============================================================================================================================================================================================

        Steps:
            1- Run the `precheck_TransPi.sh` to install tools, set up the databases and directories for

            2- Run vAMPirusv0.1.0.sh

            Usage:

                nextflow run vAMPirusv0.1.0.sh

        Help options:

                --help                          Print help information

                --fullHelp                      Print even more help information

        Mandatory arguments (choose one):

                --Analyze                       Run absolutely everything

                --dataCheck                     Assess how data performs with during processing and clustering

                --generateAAcounts              Provide vAMPirus with a translated fasta file and the merged reads you would like mapped and it will generate a protein counts file for you

                --generateReport                Provide vAMPirus with paths to necessary files to generate a vAMPirus report

        Clustering arguments:

                --nOTU                          Set this option to have vAMPirus cluster nucleotide amplicon sequence variants (ASVs) into nucleotide-based operational taxonomic units (nOTUs) - See options below to define a single percent similarity or a list

                --pOTU                          Set this option to have vAMPirus cluster nucleotide and translated ASVs into protein-based operational taxonomic units (pOTUs) - See options below to define a single percent similarity or a list

        Skip arguments:

                --skipReadProcessing            Set this option to skip all read processing steps in the pipeline

                --skipFastQC                    Set this option to skiip FastQC steps in the pipeline

                --skipAdapterRemoval            Set this option to skip adapter removal in the pipeline

                --skipPrimerRemoval             Set this option to skup Skip primer removal process

                --skipAminoTyping               Set this option to skip AminoTyping processes

                --skipTaxonomy                  Set this option to skip taxonomy assignment processes

                --skipPhylogeny                 Set this option to skip phylogeny processes

        Analysis-specific options (will override information in the config file):

            General information

                --projtag                       Set project name to be used as a prefix for output files

                --metadata                      Set path to metadata spreadsheet file to be used for report generation (must be defined if generating report)

                --mypwd                         Path to working directory that contains (i) the vAMPirus.nf script, (ii) the nextflow.config, and (iii) directory containing read libraries

                --email                         Your email for notifications for when jobs are submitted and completed

                --reads                         Path to directory containing read libraries, must have *R{1,2}.fast{a,q} in the name

                --outdir                        Name of directory to store output of vAMPirus run

        Merged read length filtering options

                --minLen                        Minimum merged read length - reads below the specified maximum read length will be used for counts only

                --maxLen                        Maximum merged read length - reads with length equal to the specified max read length will be used to identifying unique sequences and  subsequent Amplicon Sequence Variant (ASV) analysis

                --maxEE                         Use this option to set the maximum expected error rate for vsearch merging. Default is 1.

        Primer Removal options

                --GlobTrim                      Set this option to perform global trimming to reads to remove primer sequences  #,#

                --fwd                           Specify forward primer sequence pecific primer sequence on forward reads to be removed

                --rev                           Reverse primer sequence

        Amplicon analysis options

                --alpha                         Alpha value for denoising - the higher the alpha the higher the chance of false positives in ASV generation (1 or 2)

                --minSize                       Minimum size or representation for sequence to be considered in ASV generation

                --clusterNuclID                 With --nOTU set, use this option to set a single percent similarity to cluster nucleotide sequences into OTUs by [ Example: --clusterNuclID .97 ]

                --clusterNuclIDlist             With --nOTU set, use this option to perform nucleotide clustering with a comma separated list of percent similarities [ Example: --clusterNuclIDlist .95,.96,.97,.98 ]

                --clusterAAID                   With --pOTU set, use this option to set a single percent similarity for amino acid-based OTU clustering [ Example: --clusterAAID .97 ]

                --clusterAAIDlist               With --pOTU set, use this option to perform amino acid-based OTU clustering with a comma separated list of percent similarities [ Example: --clusterAAIDlist .95,.96,.97,.98 ]

                --minAA                         With --pOTU set, use this option to set the expected or minimum amino acid sequence length of open reading frames within your amplicon sequences


        Counts table options

                --asvcountID                    Similarity ID to use for ASV counts

                --ProtCountID                   Minimum amino acid sequence similarity for hit to count

                --ProtCountsLength              Minimum alignment length for hit to count


        Taxonomy assignment parameters

                --dbname                       Specify name of database to use for analysis

                --dbdir                        Path to Directory where database is being stored

                --refseq                       Toggle use of RefSeq header format; default is Reverence Viral DataBase (RVDB)

                --Bitscore                     Set minimum bitscore for Diamond command

                --

        Phylogeny analysis parameters

                --ntmodeltrax                 Use this option to use the nucleotide model of substitution determined by ModelTest-NG

                --ptmodeltrax                 Use this option to use the amino acid model of substitution determined by ModelTest-NG

        Paths to files needed for --generateAAcounts option

                --proteinFasta                 Path to protein sequence fasta file to be used for counts

                --mergedFast                   Path to merged read fastq/fasta file to be used for counts

                --sampleList                   Path to list of sample names which are mentioned in the sequence headers

        |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
        #################################################################################################

                                  Various examples on how to deploy vAMPirus

        #################################################################################################

        I. Steps for running on a local cluster and local installation of TransPi

            1- Run the `precheck_TransPi.sh` to install tools, set up the databases and directories for TransPi
            2- Run TransPi

            Usage:

                nextflow run TransPi.nf --all -with-conda ~/anaconda3/envs/TransPi

        #################################################################################################

        II. Steps for running on a local cluster and conda installation by nextflow

            1- Run the `precheck_TransPi.sh` to install tools, set up the databases and directories for TransPi
            2- Run TransPi

            Usage:

                nextflow run TransPi.nf --all -profile conda

            NOTE:
                Not recommended, not all programs are installed by conda. Use if other dependencies are manually installed

        #################################################################################################

        III. Steps for running on docker (in development)

            1- Run the `container_precheck_TransPi.sh` to install tools, set up the databases and directories for TransPi
            2- Run TransPi

            Usage:

                nextflow run TransPi.nf --all -profile docker

            NOTE:
                All necesary tools for running TransPi are pre-installed in the container
                `container_precheck_TransPi.sh` will install only the database used by TransPi

        #################################################################################################

        IV. Steps for running on singualarity (in development)

            1- Run the `container_precheck_TransPi.sh` to install tools, set up the databases and directories for TransPi
            2- Run TransPi

            Usage:

                nextflow run TransPi.nf --all -profile singularity

            NOTE:
                All necesary tools for running TransPi are pre-installed in the container
                `container_precheck_TransPi.sh` will install only the database used by TransPi

        #################################################################################################

        V. Steps for running with multiple profiles (in development - depending on profile selected)

            1- Run the `precheck_TransPi.sh` to install tools, set up the databases and directories for TransPi
            2- Run TransPi

            Usage:

                nextflow run TransPi.nf --all -profile conda,test

            NOTE:
                This will run TransPi using a test dataset and a conda environment created by Nextflow
                To run with containers first run the `container_precheck_TransPi.sh` and use -profile docker,test

        #################################################################################################

    """.stripIndent()
}
// Show help message
if (params.help) {
    helpMessage()
    exit 0
} else if (params.fullHelp) {
    fullHelpMessage()
    exit 0
}

// This will be printed to the user in each run. here thy can check if the values the selected are fine
log.info """\

        ======================================================
        vAMPirus - Virus Amplicon Sequencing Analysis Pipeline
        ======================================================
        Project name:                ${params.projtag}
        Email:                       ${params.email}
        Working directory:           ${params.mypwd}
        Minimum read length:	     ${params.minLen}
        Maximum read length:         ${params.maxLen}
        OTU cluster percentages:     ${params.clustid}
        Alpha value:                 ${params.alpha}
        Database directory:          ${params.dbdir}
        Database name:               ${params.dbname}
        Database header format:      ${params.dbhead}

        """.stripIndent()

// read files from here. This will be changed!
if (params.readsTest) {
    println("\n\tRunning vAMPirus with TEST dataset\n")
    Channel
        .from(params.readsTest)
        .map{ row -> [ row[0], [ file(row[1][0],checkIfExists: true),file(row[2][0],checkIfExists: true) ] ] }
        .ifEmpty{ exit 1, "params.readsTest was empty - no input files supplied" }
        .into{ reads_ch; reads_qc_ch }
} else {
    println("\n\tRunning vAMPirus with your dataset\n")
    Channel
        .fromFilePairs("${params.reads}", checkIfExists: true)
        .into{ reads_ch; reads_qc_ch }
}

process Build_database {
    script:
        """
        cd ${params.mypwd}
        echo -e "-- Checking if Diamond database folder is present --\\n"
        if [ ! -d DBs/diamonddb_custom/ ];then
            echo -e "-- Folder is not present, creating one and the Diamond database --\\n"
            mkdir -p DBs/diamonddb_custom/
            cd DBs/diamonddb_custom
            cp ${params.dbdir} .
            diamond makedb --in ${params.dbname} -d ${params.dbname}
            export virdb=`pwd`/${params.dbname}
            cd ../
        elif [ -d DBs/diamonddb_custom/ ];then
            echo -e "-- Folder is present. Checking if Diamond database is built --\\n"
            cd DBs/diamonddb_custom
            if [ ! -e ${params.dbname}.dmnd ];then
                echo -e "-- Diamond database not present, creating one --\\n"
                cp ${params.dbdir} .
                diamond makedb --in ${params.dbname} -d ${params.dbname}
                export virdb=`pwd`/${params.dbname}
            elif [ -e ${params.dbname}.dmnd  ];then
                echo -e "-- Diamond database already created --\\n"
                export virdb=`pwd`/${params.dbname}
            fi
            cd ../
        fi
        """
}

if (params.Analyze) {

    println("\n\tRunning vAMPirus \n")

    if (!params.skipReadProcessing) {

        if (!params.skipFastQC) {

            process QualityCheck_1 {

                label 'low_cpus'

                tag "${sample_id}"

                publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/FastQC/PreClean", mode: "copy", overwrite: true

                input:
                    tuple sample_id, file(reads) from reads_qc_ch

                output:
                    tuple sample_id, file("*_fastqc.{zip,html}") into fastqc_results_OAS

                script:
                    """
                    fastqc --quiet --threads $task.cpus $reads
                    """
            }
        }

        if (!params.skipAdapterRemoval) {

            process Adapter_Removal {

                label 'low_cpus'

                tag "${sample_id}"

                publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/AdapterRemoval", mode: "copy", overwrite: true, pattern: "*.filter.fq"
                publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/AdapterRemoval/fastpOut", mode: "copy", overwrite: true, pattern: "*.fastp.{json,html}"

                input:
                    tuple sample_id, file(reads) from reads_ch

                output:
                    tuple sample_id, file("*.fastp.{json,html}") into fastp_results
                    tuple sample_id, file("*.filter.fq") into reads_fastp_ch
                    tuple sample_id, file("*.csv") into fastp_csv

                script:
                    """
                    echo ${sample_id}

                    fastp -i ${reads[0]} -I ${reads[1]} -o left-${sample_id}.filter.fq -O right-${sample_id}.filter.fq --detect_adapter_for_pe \
                    --average_qual 25 -c --overrepresentation_analysis --html ${sample_id}.fastp.html --json ${sample_id}.fastp.json --thread ${task.cpus} \
                    --report_title ${sample_id}

                    bash get_readstats.sh ${sample_id}.fastp.json
                    """
                }
        } else {
            reads_ch
                .set{ reads_fastp_ch }
            fastp_results = Channel.empty()
        }

        if (!params.skipPrimerRemoval) {

            process Primer_Removal {

                label 'low_cpus'

                tag "${sample_id}"

                publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/PrimerRemoval", mode: "copy", overwrite: true

                input:
                    tuple sample_id, file(reads) from reads_fastp_ch

                output:
                    tuple sample_id, file("*bbduk*.fastq.gz") into ( reads_bbduk_ch, readsforqc2 )

                script:
                    // check if we need to check this outside processes
                    if ( params.fwd == "" && params.rev == "" ) {
                        """
                        bbduk.sh in1=${reads[0]} out=${sample_id}_bb_R1.fastq.gz ftl=${params.defaultFwdTrim} t=${task.cpus}
                        bbduk.sh in=${reads[1]} out=${sample_id}_bb_R2.fastq.gz ftl=${params.defaultRevTrim} t=${task.cpus}
        		        repair.sh in1=${sample_id}_bb_R1.fastq.gz in2=${sample_id}_bb_R2.fastq.gz out1=${sample_id}_bbduk_R1.fastq.gz out2=${sample_id}_bbduk_R2.fastq.gz outs=sing.fq repair
                        """
                    } else if ( params.GlobTrim && !params.GlobTrim == "" ) {
                        """
                        FTRIM=\$( echo ${GlobTrim} | cut -f 1 -d "," )
                        RTRIM=\$( echo ${GlobTrim} | cut -f 2 -d "," )
                        bbduk.sh in=${reads[0]} out=${sample_id}_bb_R1.fastq.gz ftl=\${FTRIM} t=${task.cpus}
                        bbduk.sh in=${reads[1]} out=${sample_id}_bb_R2.fastq.gz ftl=\${RTRIM} t=${task.cpus}
        		        repair.sh in1=${sample_id}_bb_R1.fastq.gz in2=${sample_id}_bb_R2.fastq.gz out1=${sample_id}_bbduk_R1.fastq.gz out2=${sample_id}_bbduk_R2.fastq.gz outs=sing.fq repair
                        """
                    } else {
                        """
                        bbduk.sh in=${reads[0]} in2=${reads[1]} out=${sample_id}_bbduk_R1.fastq.gz out2=${sample_id}_bbduk_R2.fastq.gz literal=${params.fwd},${params.rev} copyundefined=t t=${task.cpus} restrictleft=25 k=12 ordered=t mink=2 ktrim=l ecco=t rcomp=t minlength=200 tbo tpe
                        """
                    }
        	  }
        } else {
            reads_fastp_ch
                .set{ reads_bbduk_ch }
        }

        if (!params.skipFastQC) {

            process QualityCheck_2 {

                label 'low_cpus'

                tag "${sample_id}"

                publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/FastQC/PostClean", mode: "copy", overwrite: true

                input:
                    tuple sample_id, file(reads) from readsforqc2

                output:
                    tuple sample_id, file("*_fastqc.{zip,html}") into fastqc2_results_OAS

                script:
                    """
                    fastqc --quiet --threads $task.cpus $reads
                    """
            }
        }
    }

    process Read_Merging {

        label 'norm_cpus'

        tag "${sample_id}"

        publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/ReadMerging/Individual", mode: "copy", overwrite: true, pattern: "*mergedclean.fastq"
        publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/ReadMerging/Individual/notmerged", mode: "copy", overwrite: true, pattern: "*notmerged*.fastq"
        input:
            tuple sample_id, file(reads) from reads_bbduk_ch

        output:
            file("*_mergedclean.fastq") into reads_vsearch1_ch
            file("*.name") into names
            file("*notmerged*.fastq") into notmerged

        script:
            """
            vsearch --fastq_mergepairs ${reads[0]} --reverse ${reads[1]} --threads ${task.cpus} --fastqout ${sample_id}_mergedclean.fastq --fastqout_notmerged_fwd ${sample_id}_notmerged_fwd.fastq --fastqout_notmerged_rev ${sample_id}_notmerged_rev.fastq --fastq_maxee ${params.maxEE} --relabel ${sample_id}.
            echo ${sample_id} > ${sample_id}.name
            """

    }

    process Compile_Reads {

        label 'low_cpus'

        publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/ReadMerging/LengthFiltering", mode: "copy", overwrite: true

        input:
            file(reads) from reads_vsearch1_ch
                .collect()

        output:
            file("*_all_merged_nonFiltered.fastq") into collect_samples_ch

        script:
            """
            cat ${reads} >>${params.projtag}_all_merged_nonFiltered.fastq
	        """
    }

    process Compile_Names {

        label 'low_cpus'

        publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/ReadMerging", mode: "copy", overwrite: true

        input:
            file(names) from names
                .collect()

        output:
            file("*sample_ids.list") into ( samplelist, samplistpotu )

        script:
            """
            cat ${names} >>${params.projtag}_sample_ids.list
            """

    }

    process Length_Filtering { //changed

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/ReadMerging/LengthFiltering", mode: "copy", overwrite: true, pattern: "*_merged_preFilt*.fasta"
        publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/ReadMerging", mode: "copy", overwrite: true, pattern: "*Lengthfiltered.fastq"
        publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/ReadMerging/Histograms/pre_length_filtering", mode: "copy", overwrite: true, pattern: "*preFilt_*st.txt"
        publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/ReadMerging/Histograms/post_length_filtering", mode: "copy", overwrite: true, pattern: "*postFilt_*st.txt"

        input:
            file(reads) from collect_samples_ch

        output:
            file("*_merged_preFilt_clean.fasta") into ( nuclCounts_mergedreads_ch, pOTU_mergedreads_ch )
            file("*_merged_clean_Lengthfiltered.fastq") into reads_vsearch2_ch
            file("*_merged_preFilt_clean.fastq") into (  mergeforprotcounts, mergeforpOTUaacounts )
            file("**hist.txt")  into histos
        script:
            """
            bbduk.sh in=${reads} bhist=${params.projtag}_all_merged_preFilt_bhist.txt qhist=${params.projtag}_all_merged_preFilt_qhist.txt gchist=${params.projtag}_all_merged_preFilt_gchist.txt aqhist=${params.projtag}_all_merged_preFilt_aqhist.txt lhist=${params.projtag}_all_merged_preFilt_lhist.txt gcbins=auto
            fastp -i ${reads} -o ${params.projtag}_merged_preFilt_clean.fastq -b ${params.maxLen} -l ${params.minLen} --thread ${task.cpus} -n 1
            reformat.sh in=${params.projtag}_merged_preFilt_clean.fastq out=${params.projtag}_merged_preFilt_clean.fasta t=${task.cpus}
            bbduk.sh in=${params.projtag}_merged_preFilt_clean.fastq out=${params.projtag}_merged_clean_Lengthfiltered.fastq minlength=${params.maxLen} maxlength=${params.maxLen} t=${task.cpus}
            bbduk.sh in=${params.projtag}_merged_clean_Lengthfiltered.fastq bhist=${params.projtag}_all_merged_postFilt_bhist.txt qhist=${params.projtag}_all_merged_postFilt_qhist.txt gchist=${params.projtag}_all_merged_postFilt_gchist.txt aqhist=${params.projtag}_all_merged_postFilt_aqhist.txt lhist=${params.projtag}_all_merged_postFilt_lhist.txt gcbins=auto
	        """
    }

    process Extract_Uniques {

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/ReadProcessing/ReadMerging/Uniques", mode: "copy", overwrite: true

        input:
            file(reads) from reads_vsearch2_ch

        output:
            file("*unique_sequences.fasta") into reads_vsearch3_ch

        script:
            """
            vsearch --derep_fulllength ${reads} --sizeout --relabel_keep --output ${params.projtag}_unique_sequences.fasta
            """
    }

    process Identify_ASVs {

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/Clustering/ASVs/ChimeraCheck", mode: "copy", overwrite: true

        input:
            file(reads) from reads_vsearch3_ch

        output:
            file("*notChecked.fasta") into reads_vsearch4_ch

        script:
            """
            vsearch --cluster_unoise ${reads} --unoise_alpha ${params.alpha} --relabel ASV --centroids ${params.projtag}_notChecked.fasta --minsize ${params.minSize}
            """
    }

    process Chimera_Check {

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/Clustering/ASVs", mode: "copy", overwrite: true

        input:
            file(fasta) from reads_vsearch4_ch

        output:
            file("*ASVs_all.fasta") into ( reads_vsearch5_ch, nucl2aa, asvsforAminotyping, asvfastaforcounts, asvaminocheck )

        script:
            """
	        vsearch --uchime3_denovo ${fasta} --relabel ASV --nonchimeras ${params.projtag}_ASVs_all.fasta
            """
    }

    // UNTIL HERE DEFAULT

    if (params.nOTU) {

        process NucleotideBased_ASV_clustering {

            label 'norm_cpus'

            publishDir "${params.mypwd}/${params.outdir}/Clustering/nOTU", mode: "copy", overwrite: true, pattern: '*otu*.fasta'

            input:
                file(fasta) from reads_vsearch5_ch

            output:
                tuple file("*_otu*.fasta"), file("*ASV_all.fasta") into ( nuclFastas_forDiamond_ch, nuclFastas_forCounts_ch, nuclFastas_forMatrix_ch)
                file("*_otu*.fasta") into fileforMafft

            script:
            if (params.clusterNuclIDlist) {
                """
                for id in `echo ${params.clusterNuclIDlist} | tr "," "\n"`;done
                    vsearch --cluster_fast ${fasta} --centroids ${params.projtag}_otu\${id}.fasta --threads ${task.cpus} --relabel nOTU --id \${id}
                done
                cp ${fasta} ${params.projtag}_ASV_all.fasta
                """
            } else if (params.clusterNuclID) {
                """
                id=${params.clusterNuclID}
                vsearch --cluster_fast ${fasta} --centroids ${params.projtag}_otu\${id}.fasta --threads ${task.cpus} --relabel nOTU --id \${id}
                cp ${fasta} ${params.projtag}_ASV_all.fasta
                """
            }
        }
    } else {
        reads_vsearch5_ch
	       .into{ nuclFastas_forDiamond_ch; nuclFastas_forCounts_ch; fileforMafft; nuclFastas_forMatrix_ch }
    }

    if (!params.skipTaxonomy) {

        process Nucleotide_Taxonomy_Assignment {

            label 'norm_cpus'

            publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/ASVs/Taxonomy", mode: "copy", overwrite: true, pattern: '*ASV*.{fasta,csv,tsv}'
            publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/nOTU/Taxonomy", mode: "copy", overwrite: true, pattern: '*otu*.{fasta,csv,tsv}'
            publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/ASVs/Taxonomy/DiamondOutput", mode: "copy", overwrite: true, pattern: '*ASV*dmd.out'
            publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/nOTU/Taxonomy/DiamondOutput", mode: "copy", overwrite: true, pattern: '*otu*dmd.out'

            input:
                file(reads) from nuclFastas_forDiamond_ch

            output:
                file("*.fasta") into tax_labeled_fasta
                tuple file("*_phyloseqObject.csv"), file("*summaryTable.tsv"), file("*dmd.out") into summary_diamond
                file("*_summary_for_plot.csv") into taxplot1
            script:
                """
                cp ${params.mypwd}/bin/rename_seq.py .
                virdb=${params.mypwd}/DBs/diamonddb_custom/${params.dbname}
                grep ">" \${virdb} > headers.list
                headers="headers.list"
                for filename in ${reads};do
                    name=\$(ls \${filename} | awk -F ".fasta" '{print \$1}')
                    diamond blastx -q \${filename} -d \${virdb} -p ${task.cpus} --min-score 50 --more-sensitive -o "\$name"_dmd.out -f 6 qseqid qlen sseqid qstart qend qseq sseq length qframe evalue bitscore pident btop --max-target-seqs 1
                    echo "Preparing lists to generate summary .csv's"
                    echo "[Best hit accession number]" > access.list
                    echo "[e-value]" > evalue.list
                    echo "[Bitscore]" > bit.list
                    echo "[Percent ID (aa)]" > pid.list
                    echo "[Organism ID]" > "\$name"_virus.list
                    echo "[Gene]" > "\$name"_genes.list
                    grep ">" \${filename} | awk -F ">" '{print \$2}' > seqids.lst
                    echo "extracting genes and names"
                    touch new_"\$name"_asvnames.txt
                    j=1
                    if [ `echo \${filename} | grep -c "otu"` -eq 1 ];then
                        echo "[OTU#]" > otu.list
                        echo "[OTU sequence length]" > length.list
                        for s in \$(cat seqids.lst);do
                            echo "Checking for \$s hit in diamond output"
                            if [[ ${params.refseq} == "T" ]];then
                                echo "RefSeq headers specified"
                                if [[ "\$(grep -wc "\$s" "\$name"_dmd.out)" -eq 1 ]];then
                                    echo "Yep, there was a hit for \$s"
                                    echo "Extracting the information now:"
                                    acc=\$(grep -w "\$s" "\$name"_dmd.out | awk '{print \$3}')
                                    echo "\$s" >> otu.list
                                    echo "\$acc" >> access.list
                                    line="\$(grep -w "\$s" "\$name"_dmd.out)"
                                    echo "\$line" | awk '{print \$10}' >> evalue.list
                                    echo "\$line" | awk '{print \$11}' >> bit.list
                                    echo "\$line" | awk '{print \$12}' >> pid.list
                                    echo "\$line" | awk '{print \$2}' >> length.list
                                    echo "Extracting virus and gene ID for \$s now"
                                    gene=\$(grep -w "\$acc" "\$headers" | awk -F "." '{ print \$2 }' | awk -F "[" '{ print \$1 }' | awk -F " " print substr(\$0, index(\$0,\$2)) | sed 's/ /_/g') &&
                                    echo "\$gene" | sed 's/_/ /g' >> "\$name"_genes.list
                                    virus=\$(grep -w "\$acc" "\$headers" | awk -F "[" '{ print \$2 }' | awk -F "]" '{ print \$1 }'| sed 's/ /_/g')
                                    echo "\$virus" | sed 's/_/ /g' >> "\$name"_virus.list
                                    echo ">OTU\${j}_"\$virus"_"\$gene"" >> new_"\$name"_asvnames.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                else
                                    echo "Ugh, there was no hit for \$s .."
                                    echo "We still love \$s though and we will add it to the final fasta file"
                                    echo "\$s" >> otu.list
                                    echo "NO_HIT" >> access.list
                                    echo "NO_HIT" >> "\$name"_genes.list
                                    echo "NO_HIT" >> "\$name"_virus.list
                                    echo "NO_HIT" >> evalue.list
                                    echo "NO_HIT" >> bit.list
                                    echo "NO_HIT" >> pid.list
                                    echo "NO_HIT" >> length.list
                                    virus="NO"
                                    gene="HIT"
                                    echo ">OTU\${j}_"\$virus"_"\$gene"" >> new_"\$name"_asvnames.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                fi
                            else
                                echo "Using RVDB headers."
                                if [[ "\$(grep -wc "\$s" "\$name"_dmd.out)" -eq 1 ]];then
                                    echo "Yep, there was a hit for \$s"
                                    echo "Extracting the information now:"
                                    acc=\$(grep -w "\$s" "\$name"_dmd.out | awk '{print \$3}' | awk -F "|" '{print \$3}')
                                    echo "\$s" >> otu.list
                                    echo "\$acc" >> access.list
                                    line="\$(grep -w "\$s" "\$name"_dmd.out)"
                                    echo "\$line" | awk '{print \$10}' >> evalue.list
                                    echo "\$line" | awk '{print \$11}' >> bit.list
                                    echo "\$line" | awk '{print \$12}' >> pid.list
                                    echo "\$line" | awk '{print \$2}' >> length.list
                                    echo "Extracting virus and gene ID for \$s now"
                                    gene=\$(grep -w "\$acc" "\$headers" | awk -F "|" '{ print \$6 }' | awk -F "[" '{ print \$1 }' | sed 's/ /_/g') &&
                                    echo "\$gene" | sed 's/_/ /g' >> "\$name"_genes.list
                                    virus=\$(grep -w "\$acc" "\$headers" | awk -F "|" '{ print \$6 }' | awk -F "[" '{ print \$2 }' | awk -F "]" '{print \$1}' | sed 's/ /_/g') &&
                                    echo "\$virus" | sed 's/_/ /g' >> "\$name"_virus.list
                                    echo ">OTU\${j}_"\$virus"_"\$gene"" >> new_"\$name"_asvnames.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                else
                                    echo "Ugh, there was no hit for \$s .."
                                    echo "We still love \$s though and we will add it to the final fasta file"
                                    echo "\$s" >> otu.list
                                    echo "NO_HIT" >> access.list
                                    echo "NO_HIT" >> "\$name"_genes.list
                                    echo "NO_HIT" >> "\$name"_virus.list
                                    echo "NO_HIT" >> evalue.list
                                    echo "NO_HIT" >> bit.list
                                    echo "NO_HIT" >> pid.list
                                    echo "NO_HIT" >> length.list
                                    virus="NO"
                                    gene="HIT"
                                    echo ">OTU\${j}_"\$virus"_"\$gene"" >> new_"\$name"_asvnames.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                fi
                            fi
                            echo "Done with \$s"
                            done
                    else
                        for s in \$(cat seqids.lst);do
                            echo "[ASV#]" > otu.list
                            echo "[ASV sequence length]" > length.list
                            echo "Checking for \$s hit in diamond output"
                            if [[ ${params.refseq} == "T" ]];then
                                echo "RefSeq headers specified"
                                if [[ "\$(grep -wc "\$s" "\$name"_dmd.out)" -eq 1 ]];then
                                    echo "Yep, there was a hit for \$s"
                                    echo "Extracting the information now:"
                                    acc=\$(grep -w "\$s" "\$name"_dmd.out | awk '{print \$3}')
                                    echo "\$s" >> otu.list
                                    echo "\$acc" >> access.list
                                    line="\$(grep -w "\$s" "\$name"_dmd.out)"
                                    echo "\$line" | awk '{print \$10}' >> evalue.list
                                    echo "\$line" | awk '{print \$11}' >> bit.list
                                    echo "\$line" | awk '{print \$12}' >> pid.list
                                    echo "\$line" | awk '{print \$2}' >> length.list
                                    echo "Extracting virus and gene ID for \$s now"
                                    gene=\$(grep -w "\$acc" "\$headers" | awk -F "." '{ print \$2 }' | awk -F "[" '{ print \$1 }' | awk -F " " print substr(\$0, index(\$0,\$2)) | sed 's/ /_/g') &&
                                    echo "\$gene" | sed 's/_/ /g' >> "\$name"_genes.list
                                    virus=\$(grep -w "\$acc" "\$headers" | awk -F "[" '{ print \$2 }' | awk -F "]" '{ print \$1 }'| sed 's/ /_/g')
                                    echo "\$virus" | sed 's/_/ /g' >> "\$name"_virus.list
                                    echo ">ASV\${j}_"\$virus"_"\$gene"" >> new_"\$name"_asvnames.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                else
                                    echo "Ugh, there was no hit for \$s .."
                                    echo "We still love \$s though and we will add it to the final fasta file"
                                    echo "\$s" >> otu.list
                                    echo "NO_HIT" >> access.list
                                    echo "NO_HIT" >> "\$name"_genes.list
                                    echo "NO_HIT" >> "\$name"_virus.list
                                    echo "NO_HIT" >> evalue.list
                                    echo "NO_HIT" >> bit.list
                                    echo "NO_HIT" >> pid.list
                                    echo "NO_HIT" >> length.list
                                    virus="NO"
                                    gene="HIT"
                                    echo ">ASV\${j}_"\$virus"_"\$gene"" >> new_"\$name"_asvnames.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                fi
                            else
                                echo "Using RVDB headers."
                                if [[ "\$(grep -wc "\$s" "\$name"_dmd.out)" -eq 1 ]];then
                                    echo "Yep, there was a hit for \$s"
                                    echo "Extracting the information now:"
                                    acc=\$(grep -w "\$s" "\$name"_dmd.out | awk '{print \$3}' | awk -F "|" '{print \$3}')
                                    echo "\$s" >> otu.list
                                    echo "\$acc" >> access.list
                                    line="\$(grep -w "\$s" "\$name"_dmd.out)"
                                    echo "\$line" | awk '{print \$10}' >> evalue.list
                                    echo "\$line" | awk '{print \$11}' >> bit.list
                                    echo "\$line" | awk '{print \$12}' >> pid.list
                                    echo "\$line" | awk '{print \$2}' >> length.list
                                    echo "Extracting virus and gene ID for \$s now"
                                    gene=\$(grep -w "\$acc" "\$headers" | awk -F "|" '{ print \$6 }' | awk -F "[" '{ print \$1 }' | sed 's/ /_/g') &&
                                    echo "\$gene" | sed 's/_/ /g' >> "\$name"_genes.list
                                    virus=\$(grep -w "\$acc" "\$headers" | awk -F "|" '{ print \$6 }' | awk -F "[" '{ print \$2 }' | awk -F "]" '{print \$1}' | sed 's/ /_/g') &&
                                    echo "\$virus" | sed 's/_/ /g' >> "\$name"_virus.list
                                    echo ">ASV\${j}_"\$virus"_"\$gene"" >> new_"\$name"_asvnames.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                else
                                    echo "Ugh, there was no hit for \$s .."
                                    echo "We still love \$s though and we will add it to the final fasta file"
                                    echo "\$s" >> otu.list
                                    echo "NO_HIT" >> access.list
                                    echo "NO_HIT" >> "\$name"_genes.list
                                    echo "NO_HIT" >> "\$name"_virus.list
                                    echo "NO_HIT" >> evalue.list
                                    echo "NO_HIT" >> bit.list
                                    echo "NO_HIT" >> pid.list
                                    echo "NO_HIT" >> length.list
                                    virus="NO"
                                    gene="HIT"
                                    echo ">ASV\${j}_"\$virus"_"\$gene"" >> new_"\$name"_asvnames.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                fi
                            fi
                            echo "Done with \$s"
                        done
                    fi
                    echo "Now editing "\$name" fasta headers"
                    ###### rename_seq.py
                    ./rename_seq.py \${filename} new_"\$name"_asvnames.txt "\$name"_TaxonomyLabels.fasta
                    awk 'BEGIN {RS=">";FS="\\n";OFS=""} NR>1 {print ">"\$1; \$1=""; print}' "\$name"_TaxonomyLabels.fasta >"\$name"_tmpssasv.fasta
                    echo "[Sequence header]" > newnames.list
                    cat new_"\$name"_asvnames.txt >> newnames.list
                    touch sequence.list
                    echo "     " > sequence.list
                    grep -v ">" "\$name"_tmpssasv.fasta >> sequence.list
                    rm "\$name"_tmpssasv.fasta
                    paste -d "," sequence.list "\$name"_virus.list "\$name"_genes.list otu.list newnames.list length.list bit.list evalue.list pid.list access.list >> "\$name"_phyloseqObject.csv
                    paste -d"\t" otu.list access.list "\$name"_virus.list "\$name"_genes.list sequence.list length.list bit.list evalue.list pid.list >> "\$name"_summaryTable.tsv
                    for x in *phyloseqObject.csv;do
                        echo "\$x"
                        lin=\$(( \$(wc -l \$x | awk '{print \$1}')-1))
                        tail -"\$lin" \$x | awk -F "," '{print \$2}' > tmpcol.list;
                        sed 's/ /_/g' tmpcol.list > tmp2col.list;
                        cat tmp2col.list | sort | uniq -c | sort -nr | awk '{print \$2","\$1}' > \${name}_summary_for_plot.csv;
                        rm tmpcol.list tmp2col.list
                    done
                    rm evalue.list ; rm sequence.list ; rm bit.list ; rm pid.list ; rm length.list seqids.lst otu.list ;
                    rm *asvnames.txt
                    rm "\$name"_virus.list
                    rm "\$name"_genes.list
                    rm newnames.list
                    rm access.list
                    echo "Done Assigning Taxonomy To : \${filename} "
                done
                rm headers.list
                """
        }
    }

    process Generate_Counts_Tables_Nucleotide {

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/ASVs/Counts", mode: "copy", overwrite: true, pattern: '*ASV*.{biome,csv}'
        publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/nOTU/Counts", mode: "copy", overwrite: true, pattern: '*otu*.{biome,csv}'

        input:
            file(reads) from nuclFastas_forCounts_ch
            file(merged) from nuclCounts_mergedreads_ch

        output:
            tuple file("*_counts.csv"), file("*_counts.biome") into counts_vsearch

        script:
            """
            for filename in ${reads};do
                if [ `echo \${filename} | grep -c "otu"` -eq 1 ];then
                    ident=\$( echo \${filename} | awk -F "otu" '{print \$2}' | awk -F ".fasta" '{print \$1}')
                    name=\$( echo \${filename} | awk -F ".fasta" '{print \$1}')
                    vsearch --usearch_global ${merged} --db \${filename} --id \${ident} --threads ${task.cpus} --otutabout \${name}_counts.txt --biomout \${name}_counts.biome
                    cat \${name}_counts.txt | tr "\t" "," >\${name}_counts.csv
                else
                    name=\$( echo \${filename} | awk -F ".fasta" '{print \$1}')
                    vsearch --usearch_global ${merged} --db \${filename} --id ${params.asvcountID} --threads ${task.cpus} --otutabout "\$name"_counts.txt --biomout "\$name"_counts.biome
                    cat \${name}_counts.txt | tr "\t" "," >\${name}_counts.csv
                fi
            done
            """
    }

    process Generate_Matrix {

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/ASVs/Matrix", mode: "copy", overwrite: true, pattern: '*ASV*.matrix'
        publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/nOTU/Matrix", mode: "copy", overwrite: true, pattern: '*otu*.matrix'

        input:
            file(reads) from nuclFastas_forMatrix_ch

        output:
            file("*.matrix") into clustmatrices

        script:
            // remove if statement later (no fin)
            """
            for filename in ${reads};do
                if [ `echo \${filename} | grep -c "otu"` -eq 1 ];then
                    ident=\$( echo \${filename} | awk -F "otu" '{print \$2}' | awk -F ".fasta" '{print \$1}')
                    name=\$( echo \${filename}| awk -F ".fasta" '{print \$1}')
                    clustalo -i \${filename} --distmat-out=\${name}_PairwiseDistanceq.matrix --full --force --threads=${task.cpus}
                    clustalo -i \${filename} --distmat-out=\${name}_PercentIDq.matrix --percent-id --full --force --threads=${task.cpus}
                    for x in *.matrix;do
                        pre=\$(echo "\$x" | awk -F "q.matrix" '{print \$1}')
                        ya=\$(wc -l \$x | awk '{print \$1}')
                        echo "\$(( \$ya-1))"
                        tail -"\$(( \$ya-1))" \$x > "\$pre".matrix
                        rm \$x
                    done
                else
                    name=\$( echo \${filename} | awk -F ".fasta" '{print \$1}')
                    clustalo -i \${filename} --distmat-out=\${name}_PairwiseDistanceq.matrix --full --force --threads=${task.cpus}
                    clustalo -i \${filename} --distmat-out=\${name}_PercentIDq.matrix --percent-id --full --force --threads=${task.cpus}
                    for x in *.matrix;do
                        pre=\$(echo "\$x" | awk -F "q.matrix" '{print \$1}')
                        ya=\$(wc -l \$x | awk '{print \$1}')
                        echo "\$(( \$ya-1))"
                        tail -"\$(( \$ya-1))" \$x > "\$pre".matrix
                        rm \$x
                    done
                fi
            done
            """
    }

    if (!params.skipPhylogeny) {

        process Nucleotide_Phylogeny {

            label 'norm_cpus'

            publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/Phylogeny/Alignment", mode: "copy", overwrite: true,  pattern: '*aln.*'
            publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/Phylogeny/ModelTest", mode: "copy", overwrite: true, pattern: '*.tree'
            publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/Phylogeny/ModelTest", mode: "copy", overwrite: true, pattern: '*aln*log'
            publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/Phylogeny/Modeltest", mode: "copy", overwrite: true, pattern: '*model.summary'
            publishDir "${params.mypwd}/${params.outdir}/Analyses/Nucleotide/Phylogeny/RAxML", mode: "copy", overwrite: true, pattern: '*raxml*'

            input:
                file(reads) from fileforMafft

            output:
                tuple file("*_aln.fasta"), file("*_aln.html"), file("*.tree"), file("*.log"), file("*raxml*"), file("*model.summary") into align_results

            script:
                """
                # Nucleotide_Alignment
                pre=\$(echo ${reads} | awk -F ".fasta" '{print \$1}' )
                mafft --thread ${task.cpu} --maxiterate 15000 --auto ${reads} >\${pre}_ALN.fasta
                trimal -in \${pre}_ALN.fasta -out \${pre}_aln.fasta -keepheader -fasta -automated1 -htmlout \${pre}_aln.html

                # Nucleotide_ModelTest
                modeltest-ng -i \${pre}_aln.fasta -p ${task.cpus} -d nt -s 203 --disable-checkpoint
                echo "Modeltest analysis complete :)"
                echo "Modeltest-ng results summary:" > \${pre}_model.summary
                tail -7 \${pre}_aln.fasta.log >> \${pre}_model.summary

                # Nucleotide_Phylogeny
                if [ "${params.ntraxcust}" != "" ];then
                    raxml-ng --all --msa \${pre}_aln.fasta --prefix \${pre} --threads ${task.cpus} ${params.ntraxcust}
                elif [ "${params.ntmodelt}" != "" ];then
                    mod=\$(tail -14 \${pre}_aln.fasta.log| head -1 | awk -F "--model " '{print \$2}')
                    raxml-ng --all --msa \${pre}_aln.fasta --model \${mod} --seed 2 --blopt nr_safe --threads ${task.cpus} --tree \${pre}_aln.fasta.raxml.startTree --bs-trees autoMRE --prefix \${pre} --redo
                else
                    raxml-ng --all --msa \${pre}_aln.fasta --model GTR --seed 2 --blopt nr_safe --threads ${task.cpus} --tree \${pre}_aln.fasta.raxml.startTree --bs-trees autoMRE --prefix \${pre} --redo
                fi
                """
        }
    }

    if (!params.skipAminoTyping) {

        process Translate_For_AminoTyping {

            label 'norm_cpus'

            conda 'python=2.7'

            publishDir "${params.mypwd}/${params.outdir}/Clustering/AminoTypes/Translation", mode: "copy", overwrite: true

            input:
                file(fasta) from asvsforAminotyping

            output:
                file("${params.projtag}_all_translations.fasta") into amintypegen
                file("${params.projtag}_translation_report") into proteinstage_vap_report

            script:
                """
                ${tools}/virtualribosomev2/dna2pep.py ${fasta} -r all -x -o none --fasta ${params.projtag}_all_translations.fasta --report ${params.projtag}_translation_report
                """
        }

        process Generate_AminoTypes {

            label 'norm_cpus'

            publishDir "${params.mypwd}/${params.outdir}/Clustering/AminoTypes/SummaryFiles", mode: "copy", overwrite: true, pattern: '*.{clstr,csv,gc}'
            publishDir "${params.mypwd}/${params.outdir}/Clustering/AminoTypes/Problematic", mode: "copy", overwrite: true, pattern: '*problematic*.{fasta}'
            publishDir "${params.mypwd}/${params.outdir}/Clustering/AminoTypes", mode: "copy", overwrite: true, pattern: '*AminoTypes_noTaxonomy.{fasta}'

            input:
                file(prot) from amintypegen
                file(asvs) from asvaminocheck

            output:
                tuple file("*.fasta"), file("${params.projtag}_AminoTypes.clstr"), file("${params.projtag}_AminoType_summary_map.csv"), file("${params.projtag}_clustered.gc") into ( supplementalfiles )
                file("${params.projtag}_AminoTypes_noTaxonomy.fasta") into ( aminotypesCounts, aminotypesMafft, aminotypesClustal, aminotypesBlast )

            script:
                """
                cp ${params.mypwd}/bin/rename_seq.py .
                awk 'BEGIN{RS=">";ORS=""}length(\$2)>${params.minAA}{print ">"\$0}' ${prot} >${params.projtag}_filtered_translations.fasta
                awk 'BEGIN{RS=">";ORS=""}length(\$2)<${params.minAA}{print ">"\$0}' ${prot} >${params.projtag}_problematic_translations.fasta
                if [ `wc -l ${params.projtag}_problematic_translations.fasta | awk '{print \$1}'` -gt 1 ];then
                    grep ">" ${params.projtag}_problematic_translations.fasta | awk -F ">" '{print \$2}' > problem_tmp.list
                    seqtk subseq ${asvs} problem_tmp.list > ${params.projtag}_problematic_nucleotides.fasta
                else
                    rm ${params.projtag}_problematic_translations.fasta
                fi
                cd-hit -i ${params.projtag}_filtered_translations.fasta -c 1.0 -o ${params.projtag}_unlabeled_types.fasta
                sed 's/>Cluster />Cluster_/g' ${params.projtag}_unlabeled_types.fasta.clstr >${params.projtag}_AminoTypes.clstr
                grep ">Cluster_" ${params.projtag}_AminoTypes.clstr >tmpclusters.list
                grep -w "*" ${params.projtag}_AminoTypes.clstr | awk '{print \$3}' | awk -F "." '{print \$1}' >tmphead.list
                grep -w "*" ${params.projtag}_AminoTypes.clstr | awk '{print \$2}' | awk -F "," '{print \$1}' >tmplen.list
                paste -d"," tmpclusters.list tmphead.list >tmp.info.csv
                grep ">" ${params.projtag}_unlabeled_types.fasta >lala.list
                j=1
                for x in \$(cat lala.list);do
                    echo ">${params.projtag}_AminoType\${j}" >>${params.projtag}_aminoheaders.list
                    echo "\${x},>${params.projtag}_AminoType\${j}" >>tmpaminotype.info.csv
                    j=\$(( \${j}+1 ))
                done
                rm lala.list
                awk -F "," '{print \$2}' tmp.info.csv >>tmporder.list
                for x in \$(cat tmporder.list);do
                 	grep -w "\$x" tmpaminotype.info.csv | awk -F "," '{print \$2}' >>tmpder.list
                done
                paste -d "," tmpclusters.list tmplen.list tmphead.list tmpder.list >${params.projtag}_AminoType_summary_map.csv
                rm tmp*
                ./rename_seq.py ${params.projtag}_unlabeled_types.fasta ${params.projtag}_aminoheaders.list ${params.projtag}_AminoTypes_noTaxonomy.fasta
                stats.sh in=${params.projtag}_AminoTypes_noTaxonomy.fasta gc=${params.projtag}_clustered.gc gcformat=4
                """
	    }

        process Generate_AminoType_Matrix {

            label 'norm_cpus'

            publishDir "${params.mypwd}/${params.outdir}/Analyses/AminoTypes/Matrix", mode: "copy", overwrite: true

            input:
                file(prot) from aminotypesClustal

            output:
                file("*.matrix") into proclustmatrices

            script:
                """
                name=\$( echo ${prot} | awk -F ".fasta" '{print \$1}')
                clustalo -i ${prot} --distmat-out=\${name}_PairwiseDistanceq.matrix --full --force --threads=${task.cpus}
                clustalo -i ${prot} --distmat-out=\${name}_PercentIDq.matrix --percent-id --full --force --threads=${task.cpus}
                for x in *.matrix;do
                    pre=\$(echo "\$x" | awk -F "q.matrix" '{print \$1}')
                    ya=\$(wc -l \$x | awk '{print \$1}')
                    echo "\$(( \$ya-1))"
                    tail -"\$(( \$ya-1))" \$x > "\$pre".matrix
                    rm \$x
                done
                """
        }

        if (!params.skipTaxonomy) {

            process Taxonomy_Assignment_AminoTypes {

                label 'norm_cpus'

                publishDir "${params.mypwd}/${params.outdir}/Analyses/AminoTypes/Taxonomy", mode: "copy", overwrite: true, pattern: '*.{csv,tsv}'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/AminoTypes/Taxonomy", mode: "copy", overwrite: true, pattern: '*TaxonomyLabels.fasta'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/AminoTypes/Taxonomy/DiamondOutput", mode: "copy", overwrite: true, pattern: '*dmd.out'

                input:
                    file(reads) from aminotypesBlast

                output:
                    tuple file("*_phyloseqObject.csv"), file("*_summaryTable.tsv"), file("*dmd.out") into summary_AA_diamond
                    file("*_summary_for_plot.csv") into taxplot2
                    file("*TaxonomyLabels.fasta") into tax_labeled_fasta2

                script:
                    """
                    cp ${params.mypwd}/bin/rename_seq.py .
                    virdb=${params.mypwd}/DBs/diamonddb_custom/${params.dbname}
                    grep ">" \${virdb} >> headers.list
                    headers="headers.list"
                    name=\$(ls ${reads} | awk -F "_noTaxonomy" '{print \$1}')
                    diamond blastp -q ${reads} -d \${virdb} -p ${task.cpus} --min-score 50 --more-sensitive -o "\$name"_dmd.out -f 6 qseqid qlen sseqid qstart qend qseq sseq length qframe evalue bitscore pident btop --max-target-seqs 1
                    echo "Preparing lists to generate summary .csv's"
                    echo "[Best hit accession number]" >access.list
                    echo "[pOTU sequence length]" >length.list
                    echo "[e-value]" >evalue.list
                    echo "[Bitscore]" >bit.list
                    echo "[Percent ID (aa)]" >pid.list
                    echo "[AminoType#]" >otu.list
                    echo "[Virus ID]" >"\$name"_virus.list
                    echo "[Gene]" >"\$name"_genes.list
                    grep ">" ${reads} | awk -F ">" '{print \$2}' > seqids.lst
                    echo "extracting genes and names"
                    touch new_"\$name"_asvnames.txt
                    j=1
                    for s in \$(cat seqids.lst);do
                        echo "Checking for \$s hit in diamond output"
                            if [[ ${params.refseq} == "T" ]];then
                                echo "RefSeq headers specified"
                                if [[ "\$(grep -wc "\$s" "\$name"_dmd.out)" -eq 1 ]];then
                                    echo "Yep, there was a hit for \$s"
                                    echo "Extracting the information now:"
                                    acc=\$(grep -w "\$s" "\$name"_dmd.out | awk '{print \$3}')
                                    echo "\$s" >> otu.list
                                    echo "\$acc" >> access.list
                                    line="\$(grep -w "\$s" "\$name"_dmd.out)"
                                    echo "\$line" | awk '{print \$10}' >>evalue.list
                                    echo "\$line" | awk '{print \$11}' >>bit.list
                                    echo "\$line" | awk '{print \$12}' >>pid.list
                                    echo "\$line" | awk '{print \$2}' >>length.list
                                    echo "Extracting virus and gene ID for \$s now"
                                    gene=\$(grep -w "\$acc" "\$headers" | awk -F "." '{ print \$2 }' | awk -F "[" '{ print \$1 }' | awk -F " " print substr(\$0, index(\$0,\$2)) | sed 's/ /_/g')
                                    echo "\$gene" | sed 's/_/ /g' >> "\$name"_genes.list
                                    virus=\$(grep -w "\$acc" "\$headers" | awk -F "[" '{ print \$2 }' | awk -F "]" '{ print \$1 }'| sed 's/ /_/g')
                                    echo "\$virus" | sed 's/_/ /g' >> "\$name"_virus.list
                                    echo ">AminoType\${j}_"\$virus"_"\$gene"" >> new_"\$name"_asvnames.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                else
                                    echo "Ugh, there was no hit for \$s .."
                                    echo "We still love \$s though and we will add it to the final fasta file"
                                    echo "\$s" >> otu.list
                                    echo "NO_HIT" >>access.list
                                    echo "NO_HIT" >>"\$name"_genes.list
                                    echo "NO_HIT" >>"\$name"_virus.list
                                    echo "NO_HIT" >>evalue.list
                                    echo "NO_HIT" >>bit.list
                                    echo "NO_HIT" >>pid.list
                                    echo "NO_HIT" >>length.list
                                    virus="NO"
                                    gene="HIT"
                                    echo ">AminoType\${j}_"\$virus"_"\$gene"" >> new_"\$name"_asvnames.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                            fi
                            else
                                echo "Using RVDB headers."
                                if [[ "\$(grep -wc "\$s" "\$name"_dmd.out)" -eq 1 ]];then
                                    echo "Yep, there was a hit for \$s"
                                    echo "Extracting the information now:"
                                    acc=\$(grep -w "\$s" "\$name"_dmd.out | awk '{print \$3}' | awk -F "|" '{print \$3}')
                                    echo "\$s" >>otu.list
                                    echo "\$acc" >>access.list
                                    line="\$(grep -w "\$s" "\$name"_dmd.out)"
                                    echo "\$line" | awk '{print \$10}' >>evalue.list
                                    echo "\$line" | awk '{print \$11}' >>bit.list
                                    echo "\$line" | awk '{print \$12}' >>pid.list
                                    echo "\$line" | awk '{print \$2}' >>length.list
                                    echo "Extracting virus and gene ID for \$s now"
                                    gene=\$(grep -w "\$acc" "\$headers" | awk -F "|" '{ print \$6 }' | awk -F "[" '{ print \$1 }' | sed 's/ /_/g')
                                    echo "\$gene" | sed 's/_/ /g' >>"\$name"_genes.list
                                    virus=\$(grep -w "\$acc" "\$headers" | awk -F "|" '{ print \$6 }' | awk -F "[" '{ print \$2 }' | awk -F "]" '{print \$1}' | sed 's/ /_/g')
                                    echo "\$virus" | sed 's/_/ /g' >>"\$name"_virus.list
                                    echo ">AminoType\${j}_"\$virus"_"\$gene"" >>new_"\$name"_asvnames.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                else
                                    echo "Ugh, there was no hit for \$s .."
                                    echo "We still love \$s though and we will add it to the final fasta file"
                                    echo "\$s" >>otu.list
                                    echo "NO_HIT" >>access.list
                                    echo "NO_HIT" >>"\$name"_genes.list
                                    echo "NO_HIT" >>"\$name"_virus.list
                                    echo "NO_HIT" >>evalue.list
                                    echo "NO_HIT" >>bit.list
                                    echo "NO_HIT" >>pid.list
                                    echo "NO_HIT" >>length.list
                                    virus="NO"
                                    gene="HIT"
                                    echo ">AminoType\${j}_"\$virus"_"\$gene"" >>new_"\$name"_asvnames.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                fi
                            fi
                    echo "Done with \$s"
                    done
                    echo "Now editing "\$name" fasta headers"
                    ###### rename_seq.py
                    ./rename_seq.py ${reads} new_"\$name"_asvnames.txt "\$name"_TaxonomyLabels.fasta
                    awk 'BEGIN {RS=">";FS="\\n";OFS=""} NR>1 {print ">"\$1; \$1=""; print}' "\$name"_TaxonomyLabels.fasta > "\$name"_tmpssasv.fasta
                    echo "[Sequence header]" > newnames.list
                    cat new_"\$name"_asvnames.txt >> newnames.list
                    touch sequence.list
                    echo "     " > sequence.list
                    grep -v ">" "\$name"_tmpssasv.fasta >> sequence.list
                    rm "\$name"_tmpssasv.fasta
                    paste -d "," sequence.list "\$name"_virus.list "\$name"_genes.list otu.list newnames.list length.list bit.list evalue.list pid.list access.list >> "\$name"_phyloseqObject.csv
                    paste -d"\t" otu.list access.list "\$name"_virus.list "\$name"_genes.list sequence.list length.list bit.list evalue.list pid.list >> "\$name"_summaryTable.tsv
                    for x in *phyloseqObject.csv;do
                        echo "\$x"
                        lin=\$(( \$(wc -l \$x | awk '{print \$1}')-1))
                        tail -"\$lin" \$x | awk -F "," '{print \$2}' > tmpcol.list;
                        sed 's/ /_/g' tmpcol.list > tmp2col.list;
                        cat tmp2col.list | sort | uniq -c | sort -nr | awk '{print \$2","\$1}' > \${name}_summary_for_plot.csv;
                        rm tmpcol.list tmp2col.list
                    done
                    rm evalue.list ; rm sequence.list ; rm bit.list ; rm pid.list ; rm length.list seqids.lst headers.list otu.list ;
                    rm *asvnames.txt
                    rm "\$name"_virus.list
                    rm "\$name"_genes.list
                    rm newnames.list
                    rm access.list
                    echo "Done Assigning Taxonomy To : ${reads} "
                    """
            }
        }

        if (!params.skipPhylogeny) {

            process AminoType_Phylogeny {

                label 'norm_cpus'

                publishDir "${params.mypwd}/${params.outdir}/Analyses/AminoTypes/Phylogeny/Alignment", mode: "copy", overwrite: true, pattern: '*aln.*'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/AminoTypes/Phylogeny/ModelTest", mode: "copy", overwrite: true, pattern: '*.tree'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/AminoTypes/Phylogeny/ModelTest", mode: "copy", overwrite: true, pattern: '*aln*log'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/AminoTypes/Phylogeny/Modeltest", mode: "copy", overwrite: true, pattern: '*model.summary'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/AminoTypes/Phylogeny/RAxML", mode: "copy", overwrite: true, pattern: '*raxml*'

                input:
                    file(prot) from aminotypesMafft

                output:
                    tuple file("*_aln.fasta"), file("*_aln.html"), file("*.tree"), file("*.log"), file("*raxml*"), file("*model.summary") into alignprot_results

                script:
                    """
                    # Protein_Alignment
                    pre=\$(echo ${prot} | awk -F ".fasta" '{print \$1}' )
                    mafft --thread ${task.cpu} --maxiterate 15000 --auto ${prot} >\${pre}_ALN.fasta
                    trimal -in \${pre}_ALN.fasta -out \${pre}_aln.fasta -keepheader -fasta -automated1 -htmlout \${pre}_aln.html

                    # Protein_ModelTest
                    modeltest-ng -i \${pre}_aln.fasta -p ${task.cpus} -d aa -s 203 --disable-checkpoint
                    echo "Modeltest analysis complete :)"
                    echo "Modeltest-ng results summary:" > \${pre}_model.summary
                    tail -7 \${pre}_aln.fasta.log >> \${pre}_model.summary

                    # Protein_Phylogeny
                    if [ "${params.ptraxcust}" != "" ];then
                        raxml-ng --all --msa \${pre}_aln.fasta --prefix \${pre} --threads ${task.cpus} ${params.ptraxcust}
                    elif [ "${params.ptmodeltrax}" != "" ];then
                        mod=\$(tail -14 \${pre}_aln.fasta.log| head -1 | awk -F "--model " '{print \$2}')
                        raxml-ng --all --msa \${pre}_aln.fasta --model \${mod} --seed 2 --blopt nr_safe --threads ${task.cpus} --tree \${pre}_aln.fasta.raxml.startTree --bs-trees autoMRE --prefix \${pre} --redo
                    else
                        raxml-ng --all --msa \${pre}_aln.fasta --model protGTR --seed 2 --blopt nr_safe --threads ${task.cpus} --tree \${pre}_aln.fasta.raxml.startTree --bs-trees autoMRE --prefix \${pre} --redo
                    fi
                    """
            }
        }

        process Generate_AminoTypes_Counts_Table {

            label 'norm_cpus'

            publishDir "${params.mypwd}/${params.outdir}/Analyses/AminoTypes/Counts", mode: "copy", overwrite: true

            input:
                file(fasta) from aminotypesCounts
                file(merged) from mergeforprotcounts
                file(samplist) from samplelist

            output:
                tuple file("*_protcounts.csv"), file("*dmd.out") into counts_summary

            script:
                """
                set +e
                diamond makedb --in ${fasta} --db ${fasta}
                diamond blastx -q ${merged} -d ${fasta} -p ${task.cpus} --min-score ${params.ProtCountsBit} --id ${params.ProtCountID} -l ${params.ProtCountsLength} --more-sensitive -o ${params.projtag}_protCounts_dmd.out -f 6 qseqid qlen sseqid qstart qend qseq sseq length qframe evalue bitscore pident btop --max-target-seqs 1 --max-hsps 1
                echo "[Sequence]" >tmp.col1.txt
                echo "Generating sample id list"
                grep ">" ${fasta} | awk -F ">" '{print \$2}' | sort | uniq > otuid.list
                cat otuid.list >> tmp.col1.txt
                echo "Beginning them counts tho my g"
                for y in \$( cat ${samplist} );do
                    echo "Starting with \$y now ..."
                    grep "\$y" ${params.projtag}_protCounts_dmd.out > tmp."\$y".out
                    echo "Isolated hits"
                    echo "Created uniq subject id list"
                    echo "\$y" > "\$y"_col.txt
                    echo "Starting my counts"
                    for z in \$(cat otuid.list);do
                        echo "Counting \$z hits"
        	            echo "grep -wc "\$z" >> "\$y"_col.txt"
        	            grep -wc "\$z" tmp."\$y".out >> "\$y"_col.txt
    		            echo "\$z counted"
    	            done
               done
               paste -d "," tmp.col1.txt *col.txt > ${params.projtag}_protcounts.csv
               rm tmp*
               rm *col.txt
               """
        }
    }

    if (params.pOTU) {        // ASV_nucl -> ASV_aa -> clusteraa by %id with ch-hit -> extract representative nucl sequences to generate new OTU file

        process Translation_For_ProteinBased_Clustering {

            label 'norm_cpus'

            conda 'python=2.7'

            publishDir "${params.mypwd}/${params.outdir}/Clustering/pOTU/Translation", mode: "copy", overwrite: true, pattern: '*_ASV_translations*'

            input:
                file(fasta) from nucl2aa

            output:
                file("*ASV_translations.fasta") into clustering_aa
                file("*_ASV_translations_report") into reportaa_VR
                file("*_ASV_nucleotide.fasta") into asvfastaforaaclust

            script:
                """
                ${tools}/virtualribosomev2/dna2pep.py ${fasta} -r all -x -o none --fasta ${params.projtag}_ASV_translations.fasta --report ${params.projtag}_ASV_translations_report
                cp ${fasta} ${params.projtag}_ASV_nucleotide.fasta
                """
        }

        process Generate_pOTUs {

            label 'norm_cpus'

            publishDir "${params.mypwd}/${params.outdir}/Clustering/pOTU", mode: "copy", overwrite: true, pattern: '*pOTU*.{fasta}'
            publishDir "${params.mypwd}/${params.outdir}/Clustering/pOTU/SummaryFiles", mode: "copy", overwrite: true, pattern: '*.{clstr,csv,gc}'
            publishDir "${params.mypwd}/${params.outdir}/Clustering/pOTU/Problematic", mode: "copy", overwrite: true, pattern: '*problem*.{fasta}'
            input:
                file(fasta) from clustering_aa
                file(asvs) from asvfastaforaaclust

            output:
                file("${params.projtag}_nucleotide_pOTU*.fasta") into ( pOTU_ntDiamond_ch, pOTU_nt_counts_ch, pOTU_ntmatrix_ch, pOTU_ntmafft_ch )
                file("*_aminoacid_pOTU*_noTaxonomy.fasta") into ( pOTU_aaMatrix_ch, pOTU_aaDiamond_ch, pOTU_aaMafft_ch, pOTU_aaCounts_ch )
                tuple file("*.fasta"), file("*.clstr"), file("*.csv"), file("*.gc") into ( pOTUsupplementalfiles )
            script:
            // add awk script to count seqs
            if (params.clusterAAIDlist) {
                """
                cp ${params.mypwd}/bin/rename_seq.py .
                for id in `echo ${params.clusterAAIDlist} | tr "," "\n"`;do
                        awk 'BEGIN{RS=">";ORS=""}length(\$2)>${params.minAA}{print ">"\$0}' ${params.projtag}_ASV_translations.fasta > ${params.projtag}_filtered_proteins.fasta
                        cd-hit -i ${params.projtag}_filtered_proteins.fasta -c \${id} -o ${params.projtag}_pOTU\${id}.fasta
                        sed 's/>Cluster />Cluster_/g' ${params.projtag}_pOTU\${id}.fasta.clstr >${params.projtag}_pOTU\${id}.clstr
                        grep ">Cluster_" ${params.projtag}_pOTU\${id}.clstr >temporaryclusters.list
                        y=\$(grep -c ">Cluster_" ${params.projtag}_pOTU\${id}.clstr)
                        echo ">Cluster_"\${y}"" >> ${params.projtag}_pOTU\${id}.clstr
                        t=1
                        b=1
                        for x in \$(cat temporaryclusters.list);do
                            echo "Extracting \$x"
                            name="\$( echo \$x | awk -F ">" '{print \$2}')"
                            clust="pOTU"\${t}""
                            echo "\${name}"
                            awk '/^>'\${name}'\$/,/^>Cluster_'\${b}'\$/' ${params.projtag}_pOTU\${id}.clstr > "\${name}"_"\${clust}"_tmp.list
                            t=\$(( \${t}+1 ))
                            b=\$(( \${b}+1 ))
                        done
                        ls *_tmp.list
                        u=1
                        for x in *_tmp.list;do
                            name="\$(echo \$x | awk -F "_p" '{print \$1}')"
                            echo "\${name}"
                            cluster="\$(echo \$x | awk -F "_" '{print \$3}')"
                            echo "\${cluster}"
                            grep "ASV" \$x | awk -F ", " '{print \$2}' | awk -F "_" '{print \$1}' | awk -F ">" '{print \$2}' > \${name}_\${cluster}_seqs_tmps.list
                            seqtk subseq \${params.projtag}_ASV_nucleotide.fasta \${name}_\${cluster}_seqs_tmps.list > \${name}_\${cluster}_nucleotide_sequences.fasta
                            vsearch --cluster_fast \${name}_\${cluster}_nucleotide_sequences.fasta --id 0.2 --centroids \${name}_\${cluster}_centroids.fasta
                            grep ">" \${name}_\${cluster}_centroids.fasta >> \${name}_\${cluster}_tmp_centroids.list
                            for y in \$( cat \${name}_\${cluster}_tmp_centroids.list );do
                                echo ">\${cluster}_type"\$u"" >> \${name}_\${cluster}_tmp_centroid.newheaders
                                u=\$(( \${u}+1 ))
                            done
                            u=1
                            ./rename_seq.py \${name}_\${cluster}_centroids.fasta \${name}_\${cluster}_tmp_centroid.newheaders \${cluster}_types_labeled.fasta
                        done
                        cat *_types_labeled.fasta >> ${params.projtag}_nucleotide_pOTU\${id}_noTaxonomy.fasta
                        grep -w "*" ${params.projtag}_pOTU\${id}.clstr | awk '{print \$3}' | awk -F "." '{print \$1}' >tmphead.list
                        grep -w "*" ${params.projtag}_pOTU\${id}.clstr | awk '{print \$2}' | awk -F "," '{print \$1}' >tmplen.list
                        paste -d"," temporaryclusters.list tmphead.list >tmp.info.csv
                        grep ">" ${params.projtag}_pOTU\${id}.fasta >lala.list
                        j=1
                        for x in \$(cat lala.list);do
                            echo ">${params.projtag}_pOTU\${j}" >>${params.projtag}_aminoheaders.list
                            echo "\${x},>${params.projtag}_pOTU\${j}" >>tmpaminotype.info.csv
                            j=\$(( \${j}+1 ))
                        done
                        rm lala.list
                        awk -F "," '{print \$2}' tmp.info.csv >>tmporder.list
                        for x in \$(cat tmporder.list);do
                            grep -w "\$x" tmpaminotype.info.csv | awk -F "," '{print \$2}' >>tmpder.list
                        done
                        paste -d "," temporaryclusters.list tmplen.list tmphead.list tmpder.list >${params.projtag}_pOTUCluster\${id}_summary.csv
                        ./rename_seq.py ${params.projtag}_pOTU\${id}.fasta ${params.projtag}_aminoheaders.list ${params.projtag}_aminoacid_pOTU\${id}_noTaxonomy.fasta
                        stats.sh in=${params.projtag}_aminoacid_pOTU\${id}_noTaxonomy.fasta gc=${params.projtag}_pOTU_aminoacid_clustered.gc gcformat=4
                        stats.sh in=${params.projtag}_nucleotide_pOTU\${id}_noTaxonomy.fasta gc=${params.projtag}_pOTU_nucleotide_clustered.gc gcformat=4
                        awk 'BEGIN{RS=">";ORS=""}length(\$2)<50{print ">"\$0}' ${params.projtag}_ASV_translations.fasta >${params.projtag}_pOTU\${id}_problematic_translations.fasta
                        if [ `wc -l ${params.projtag}_pOTU\${id}_problematic_translations.fasta | awk '{print \$1}'` -gt 1 ];then
                            grep ">" ${params.projtag}_pOTU\${id}_problematic_translations.fasta | awk -F ">" '{print \$2}' > problem_tmp.list
                            seqtk subseq ${params.projtag}_ASV_nucleotide.fasta problem_tmp.list > ${params.projtag}_pOTU\${id}_problematic_nucleotides.fasta
                        else
                           rm ${params.projtag}_pOTU\${id}_problematic_translations.fasta
                        fi
                        rm *.list
                        rm Cluster*
                        rm *types*
                        rm *tmp*
                        rm ${params.projtag}_pOTU\${id}.fast*
                done
                """
            } else if (params.clusterAAID) {
                """
                cp /data/alex/PVID_dinorna/AMPS/testvamp/vAMPirus/bin/rename_seq.py .
                id=${params.clusterAAID}
                awk 'BEGIN{RS=">";ORS=""}length(\$2)>${params.minAA}{print ">"\$0}' ${params.projtag}_ASV_translations.fasta > ${params.projtag}_filtered_proteins.fasta
                cd-hit -i ${params.projtag}_filtered_proteins.fasta -c ${params.clusterAAID} -o ${params.projtag}_pOTU\${id}.fasta
                sed 's/>Cluster />Cluster_/g' ${params.projtag}_pOTU\${id}.fasta.clstr >${params.projtag}_pOTU\${id}.clstr
                grep ">Cluster_" ${params.projtag}_pOTU\${id}.clstr >temporaryclusters.list
                y=\$(grep -c ">Cluster_" ${params.projtag}_pOTU\${id}.clstr)
                echo ">Cluster_"\${y}"" >> ${params.projtag}_pOTU\${id}.clstr
                t=1
                b=1
                for x in \$(cat temporaryclusters.list);do
                    echo "Extracting \$x"
                    name="\$( echo \$x | awk -F ">" '{print \$2}')"
                    clust="pOTU"\${t}""
                    echo "\${name}"
                    awk '/^>'\${name}'\$/,/^>Cluster_'\${b}'\$/' ${params.projtag}_pOTU\${id}.clstr > "\${name}"_"\${clust}"_tmp.list
                    t=\$(( \${t}+1 ))
                    b=\$(( \${b}+1 ))
                done
                ls *_tmp.list
                u=1
                for x in *_tmp.list;do
                    name="\$(echo \$x | awk -F "_p" '{print \$1}')"
                    echo "\${name}"
                    cluster="\$(echo \$x | awk -F "_" '{print \$3}')"
                    echo "\${cluster}"
                    grep "ASV" \$x | awk -F ", " '{print \$2}' | awk -F "_" '{print \$1}' | awk -F ">" '{print \$2}' > \${name}_\${cluster}_seqs_tmps.list
                    seqtk subseq ${params.projtag}_ASV_nucleotide.fasta \${name}_\${cluster}_seqs_tmps.list > \${name}_\${cluster}_nucleotide_sequences.fasta
                    vsearch --cluster_fast \${name}_\${cluster}_nucleotide_sequences.fasta --id 0.2 --centroids \${name}_\${cluster}_centroids.fasta
                    grep ">" \${name}_\${cluster}_centroids.fasta >> \${name}_\${cluster}_tmp_centroids.list
                    for y in \$( cat \${name}_\${cluster}_tmp_centroids.list );do
                        echo ">\${cluster}_type"\$u"" >> \${name}_\${cluster}_tmp_centroid.newheaders
                        u=\$(( \${u}+1 ))
                    done
                    u=1
                    ./rename_seq.py \${name}_\${cluster}_centroids.fasta \${name}_\${cluster}_tmp_centroid.newheaders \${cluster}_types_labeled.fasta
                done
                cat *_types_labeled.fasta >> ${params.projtag}_nucleotide_pOTU\${id}_noTaxonomy.fasta
                grep -w "*" ${params.projtag}_pOTU\${id}.clstr | awk '{print \$3}' | awk -F "." '{print \$1}' >tmphead.list
                grep -w "*" ${params.projtag}_pOTU\${id}.clstr | awk '{print \$2}' | awk -F "," '{print \$1}' >tmplen.list
                paste -d"," temporaryclusters.list tmphead.list >tmp.info.csv
                grep ">" ${params.projtag}_pOTU\${id}.fasta >lala.list
                j=1
                for x in \$(cat lala.list);do
                    echo ">${params.projtag}_pOTU\${j}" >>${params.projtag}_aminoheaders.list
                    echo "\${x},>${params.projtag}_pOTU\${j}" >>tmpaminotype.info.csv
                    j=\$(( \${j}+1 ))
                done
                rm lala.list
                awk -F "," '{print \$2}' tmp.info.csv >>tmporder.list
                for x in \$(cat tmporder.list);do
                    grep -w "\$x" tmpaminotype.info.csv | awk -F "," '{print \$2}' >>tmpder.list
                done
                paste -d "," temporaryclusters.list tmplen.list tmphead.list tmpder.list >${params.projtag}_pOTUCluster\${id}_summary.csv
                ./rename_seq.py ${params.projtag}_pOTU\${id}.fasta ${params.projtag}_aminoheaders.list ${params.projtag}_aminoacid_pOTU\${id}_noTaxonomy.fasta
                stats.sh in=${params.projtag}_aminoacid_pOTU\${id}_noTaxonomy.fasta gc=${params.projtag}_pOTU_aminoacid_clustered.gc gcformat=4
                stats.sh in=${params.projtag}_nucleotide_pOTU\${id}_noTaxonomy.fasta gc=${params.projtag}_pOTU_nucleotide_clustered.gc gcformat=4
                awk 'BEGIN{RS=">";ORS=""}length(\$2)<${params.minAA}{print ">"\$0}' ${params.projtag}_ASV_translations.fasta >${params.projtag}_pOTU\${id}_problematic_translations.fasta
                if [ `wc -l ${params.projtag}_pOTU\${id}_problematic_translations.fasta | awk '{print \$1}'` -gt 1 ];then
                    grep ">" ${params.projtag}_pOTU\${id}_problematic_translations.fasta | awk -F ">" '{print \$2}' > problem_tmp.list
                    seqtk subseq ${params.projtag}_ASV_nucleotide.fasta problem_tmp.list > ${params.projtag}_pOTU\${id}_problematic_nucleotides.fasta
                else
                   rm ${params.projtag}_pOTU\${id}_problematic_translations.fasta
                fi
                rm *.list
                rm Cluster*
                rm *types*
                rm *tmp*
                rm ${params.projtag}_pOTU\${id}.fast*
                """
            }
        }

        if (!params.skipTaxonomy) {

            process pOTU_Taxonomy_Assignment_1 {

                label 'norm_cpus'

                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Nucleotide/Taxonomy/SummaryFiles", mode: "copy", overwrite: true, pattern: '*.{csv,tsv}'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Nucleotide/Taxonomy/DiamondOutput", mode: "copy", overwrite: true, pattern: '*dmd.{out}'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Nucleotide/Taxonomy", mode: "copy", overwrite: true, pattern: '*.{fasta}'

                input:
                    file(reads) from pOTU_ntDiamond_ch

                output:
                    file("*.fasta") into ( pOTU_labeled )
                    tuple file("*_phyloseqObject.csv"), file("*_summaryTable.tsv"), file("*dmd.out") into summary_AAdiamond
                    file("*_summary_for_plot.csv") into taxplot3

                script:
                    """
                    set +e
                    cp ${params.mypwd}/bin/rename_seq.py .
                    virdb=${params.mypwd}/DBs/diamonddb_custom/${params.dbname}
                    grep ">" \${virdb} >> headers.list
                    headers="headers.list"
                    name=\$(ls ${reads} | awk -F ".fasta" '{print \$1}')
                    diamond blastx -q ${reads} -d \${virdb} -p ${task.cpus} --min-score 50 --more-sensitive -o "\$name"_dmd.out -f 6 qseqid qlen sseqid qstart qend qseq sseq length qframe evalue bitscore pident btop --max-target-seqs 1
                    echo "Preparing lists to generate summary .csv's"
                    echo "[Best hit accession number]" >access.list
                    echo "[pOTU sequence length]" >length.list
                    echo "[e-value]" >evalue.list
                    echo "[Bitscore]" >bit.list
                    echo "[Percent ID (aa)]" >pid.list
                    echo "[pOTU#]" >otu.list
                    echo "[Virus ID]" >"\$name"_virus.list
                    echo "[Gene]" >"\$name"_genes.list
                    grep ">" ${reads} | awk -F ">" '{print \$2}' > seqids.lst
                    echo "extracting genes and names"
                    touch new_"\$name"_headers.txt
                    j=1
                    for s in \$(cat seqids.lst);do
                        echo "Checking for \$s hit in diamond output"
                            if [[ ${params.refseq} == "T" ]];then
                                echo "RefSeq headers specified"
                                if [[ "\$(grep -wc "\$s" "\$name"_dmd.out)" -eq 1 ]];then
                                    echo "Yep, there was a hit for \$s"
                                    echo "Extracting the information now:"
                                    acc=\$(grep -w "\$s" "\$name"_dmd.out | awk '{print \$3}')
                                    echo "\$s" >> otu.list
                                    echo "\$acc" >> access.list
                                    line="\$(grep -w "\$s" "\$name"_dmd.out)"
                                    echo "\$line" | awk '{print \$10}' >>evalue.list
                                    echo "\$line" | awk '{print \$11}' >>bit.list
                                    echo "\$line" | awk '{print \$12}' >>pid.list
                                    echo "\$line" | awk '{print \$2}' >>length.list
                                    echo "Extracting virus and gene ID for \$s now"
                                    gene=\$(grep -w "\$acc" "\$headers" | awk -F "." '{ print \$2 }' | awk -F "[" '{ print \$1 }' | awk -F " " print substr(\$0, index(\$0,\$2)) | sed 's/ /_/g') &&
                                    echo "\$gene" | sed 's/_/ /g' >> "\$name"_genes.list
                                    virus=\$(grep -w "\$acc" "\$headers" | awk -F "[" '{ print \$2 }' | awk -F "]" '{ print \$1 }'| sed 's/ /_/g')
                                    echo "\$virus" | sed 's/_/ /g' >> "\$name"_virus.list
                                    echo ">pOTU\${j}_"\$virus"_"\$gene"" >> new_"\$name"_headers.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                else
                                    echo "Ugh, there was no hit for \$s .."
                                    echo "We still love \$s though and we will add it to the final fasta file"
                                    echo "\$s" >> otu.list
                                    echo "NO_HIT" >>access.list
                                    echo "NO_HIT" >>"\$name"_genes.list
                                    echo "NO_HIT" >>"\$name"_virus.list
                                    echo "NO_HIT" >>evalue.list
                                    echo "NO_HIT" >>bit.list
                                    echo "NO_HIT" >>pid.list
                                    echo "NO_HIT" >>length.list
                                    virus="NO"
                                    gene="HIT"
                                    echo ">pOTU\${j}_"\$virus"_"\$gene"" >> new_"\$name"_headers.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                            fi
                            else
                                echo "Using RVDB headers."
                                if [[ "\$(grep -wc "\$s" "\$name"_dmd.out)" -eq 1 ]];then
                                    echo "Yep, there was a hit for \$s"
                                    echo "Extracting the information now:"
                                    acc=\$(grep -w "\$s" "\$name"_dmd.out | awk '{print \$3}' | awk -F "|" '{print \$3}')
                                    echo "\$s" >>otu.list
                                    echo "\$acc" >>access.list
                                    line="\$(grep -w "\$s" "\$name"_dmd.out)"
                                    echo "\$line" | awk '{print \$10}' >>evalue.list
                                    echo "\$line" | awk '{print \$11}' >>bit.list
                                    echo "\$line" | awk '{print \$12}' >>pid.list
                                    echo "\$line" | awk '{print \$2}' >>length.list
                                    echo "Extracting virus and gene ID for \$s now"
                                    gene=\$(grep -w "\$acc" "\$headers" | awk -F "|" '{ print \$6 }' | awk -F "[" '{ print \$1 }' | sed 's/ /_/g') &&
                                    echo "\$gene" | sed 's/_/ /g' >>"\$name"_genes.list
                                    virus=\$(grep -w "\$acc" "\$headers" | awk -F "|" '{ print \$6 }' | awk -F "[" '{ print \$2 }' | awk -F "]" '{print \$1}' | sed 's/ /_/g') &&
                                    echo "\$virus" | sed 's/_/ /g' >>"\$name"_virus.list
                                    echo ">pOTU\${j}_"\$virus"_"\$gene"" >>new_"\$name"_headers.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                else
                                    echo "Ugh, there was no hit for \$s .."
                                    echo "We still love \$s though and we will add it to the final fasta file"
                                    echo "\$s" >>otu.list
                                    echo "NO_HIT" >>access.list
                                    echo "NO_HIT" >>"\$name"_genes.list
                                    echo "NO_HIT" >>"\$name"_virus.list
                                    echo "NO_HIT" >>evalue.list
                                    echo "NO_HIT" >>bit.list
                                    echo "NO_HIT" >>pid.list
                                    echo "NO_HIT" >>length.list
                                    virus="NO"
                                    gene="HIT"
                                    echo ">pOTU\${j}_"\$virus"_"\$gene"" >>new_"\$name"_headers.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                fi
                            fi
                    echo "Done with \$s"
                    done
                    echo "Now editing "\$name" fasta headers"
                    ###### rename_seq.py
                    ./rename_seq.py ${reads} new_"\$name"_headers.txt "\$name"_TaxonomyLabels.fasta
                    awk 'BEGIN {RS=">";FS="\\n";OFS=""} NR>1 {print ">"\$1; \$1=""; print}' "\$name"_TaxonomyLabels.fasta > "\$name"_tmpssasv.fasta
                    echo "[Sequence header]" > newnames.list
                    cat new_"\$name"_headers.txt >> newnames.list
                    touch sequence.list
                    echo "     " > sequence.list
                    grep -v ">" "\$name"_tmpssasv.fasta >> sequence.list
                    rm "\$name"_tmpssasv.fasta
                    paste -d "," sequence.list "\$name"_virus.list "\$name"_genes.list otu.list newnames.list length.list bit.list evalue.list pid.list access.list >> "\$name"_phyloseqObject.csv
                    paste -d"\t" otu.list access.list "\$name"_virus.list "\$name"_genes.list sequence.list length.list bit.list evalue.list pid.list >> "\$name"_summaryTable.tsv
                    for x in *phyloseqObject.csv;do
                        echo "\$x"
                        lin=\$(( \$(wc -l \$x | awk '{print \$1}')-1))
                        tail -"\$lin" \$x | awk -F "," '{print \$2}' > tmpcol.list;
                        sed 's/ /_/g' tmpcol.list > tmp2col.list;
                        cat tmp2col.list | sort | uniq -c | sort -nr | awk '{print \$2","\$1}' > \${name}_summary_for_plot.csv;
                        rm tmpcol.list tmp2col.list
                    done
                    rm evalue.list ; rm sequence.list ; rm bit.list ; rm pid.list ; rm length.list seqids.lst headers.list otu.list ;
                    rm *headers.txt
                    rm "\$name"_virus.list
                    rm "\$name"_genes.list
                    rm newnames.list
                    rm access.list
                    echo "Done Assigning Taxonomy To : ${reads} "
                    """
            }
        }

        process Generate_Nucleotide_pOTU_Counts {

            label 'norm_cpus'

            publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Nucleotide/Counts", mode: "copy", overwrite: true, pattern: '*.{biome,txt}'

            input:
                file(reads) from pOTU_nt_counts_ch
                file(merged) from pOTU_mergedreads_ch

            output:
                tuple file("*_counts.txt"), file("*_counts.biome") into pOTUcounts_vsearch

            script:
                """
                ident=\$( echo ${reads} | awk -F "OTU" '{print \$2}' | awk -F "_noTaxonomy.fasta" '{print \$1}')
                name=\$( echo ${reads} | awk -F ".fasta" '{print \$1}')
                vsearch --usearch_global ${merged} --db ${reads} --id \${ident} --threads ${task.cpus} --otutabout \${name}_counts.txt --biomout \${name}_counts.biome
                cat \${name}_counts.txt | tr "\t" "," >\${name}_counts.csv

                """
        }

        process Generate_pOTU_Nucleotide_Matrix {

            label 'norm_cpus'

            publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Nucleotide/Matrix", mode: "copy", overwrite: true

            input:
                file(reads) from pOTU_ntmatrix_ch

            output:
                file("*.matrix") into pOTUclustmatrices

            script:
                """
                ident=\$( echo ${reads} | awk -F "OTU" '{print \$2}' | awk -F ".fasta" '{print \$1}')
                name=\$( echo ${reads} | awk -F ".fasta" '{print \$1}')
                clustalo -i ${reads} --distmat-out=\${name}_PairwiseDistanceq.matrix --full --force --threads=${task.cpus}
                clustalo -i ${reads} --distmat-out=\${name}_PercentIDq.matrix --percent-id --full --force --threads=${task.cpus}
                for x in *.matrix;do
                    pre=\$(echo "\$x" | awk -F "q.matrix" '{print \$1}')
                    ya=\$(wc -l \$x | awk '{print \$1}')
                    echo "\$(( \$ya-1))"
                    tail -"\$(( \$ya-1))" \$x > "\$pre".matrix
                    rm \$x
                done
                """
        }

        if (!params.skipPhylogeny) {

            process pOTU_Nucleotide_Phylogeny {

                label 'norm_cpus'

                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Nucleotide/Phylogeny/Alignment", mode: "copy", overwrite: true, pattern: '*aln.*'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Nucleotide/Phylogeny/ModelTest", mode: "copy", overwrite: true, pattern: '*.tree'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Nucleotide/Phylogeny/ModelTest", mode: "copy", overwrite: true, pattern: '*aln*log'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Nucleotide/Phylogeny/Modeltest", mode: "copy", overwrite: true, pattern: '*model.summary'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Nucleotide/Phylogeny/RAxML", mode: "copy", overwrite: true, pattern: '*raxml*'

                input:
                    file(reads) from pOTU_ntmafft_ch

                output:
                    tuple file("*_aln.fasta"), file("*_aln.html"), file("*.tree"), file("*.log"), file("*raxml*"), file("*model.summary") into pOTU_nucleotide_phylogeny_results

                script:
                    """
                    pre=\$( echo ${reads} | awk -F "wTax" '{print \$1}' )
                    mafft --maxiterate 5000 --auto ${reads} >\${pre}_ALN.fasta
                    trimal -in \${pre}_ALN.fasta -out \${pre}_aln.fasta -keepheader -fasta -automated1 -htmlout \${pre}_aln.html

                    # pOTU_Nucleotide_ModelTest
                    modeltest-ng -i \${pre}_aln.fasta -p ${task.cpus} -d nt -s 203 --disable-checkpoint
                    echo "Modeltest analysis complete :)"
                    echo "Modeltest-ng results summary:" > \${pre}_model.summary
                    tail -7 \${pre}_aln.fasta.log >> \${pre}_model.summary

                    # pOTU_Nucleotide_Phylogeny
                    if [ "${params.ntraxcust}" != "" ];then
                        raxml-ng --all --msa \${pre}_aln.fasta --prefix \${pre} --threads ${task.cpus} ${params.ntraxcust}
                    elif [ "${params.ntmodelt}" != "" ];then
                        mod=\$(tail -14 \${pre}_aln.fasta.log | head -1 | awk -F "--model " '{print \$2}')
                        raxml-ng --all --msa \${pre}_aln.fasta --model \${mod} --seed 2 --blopt nr_safe --threads ${task.cpus} --tree \${pre}_aln.fasta.raxml.startTree --bs-trees autoMRE --prefix \${pre} --redo
                    else
                        raxml-ng --all --msa \${pre}_aln.fasta --model protGTR --seed 2 --blopt nr_safe --threads ${task.cpus} --tree \${pre}_aln.fasta.raxml.startTree --bs-trees autoMRE --prefix \${pre} --redo
                    fi
                    """
            }
        }

        process pOTU_Protein_Matrix {

            label 'norm_cpus'

            publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Aminoacid/Matrix", mode: "copy", overwrite: true

            input:
                file(prot) from pOTU_aaMatrix_ch

            output:
                file("*.matrix") into pOTUaaMatrix

            script:
                """
                name=\$( echo ${prot} | awk -F ".fasta" '{print \$1}')
                clustalo -i ${prot} --distmat-out=\${name}_PairwiseDistanceq.matrix --full --force --threads=${task.cpus}
                clustalo -i ${prot} --distmat-out=\${name}_PercentIDq.matrix --percent-id --full --force --threads=${task.cpus}
                for x in *.matrix;do
                    pre=\$(echo "\$x" | awk -F "q.matrix" '{print \$1}')
                    ya=\$(wc -l \$x | awk '{print \$1}')
                    echo "\$(( \$ya-1))"
                    tail -"\$(( \$ya-1))" \$x > "\$pre".matrix
                    rm \$x
                done
                """
        }

        if (!params.skipTaxonomy) {

            process pOTUaa_Taxonomy_Assignment_2 {

                label 'norm_cpus'

                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Aminoacid/Taxonomy/SummaryFiles", mode: "copy", overwrite: true, pattern: '*.{csv,tsv}'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Aminoacid/Taxonomy/DiamondOutput", mode: "copy", overwrite: true, pattern: '*dmd.{out}'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Aminoacid/Taxonomy", mode: "copy", overwrite: true, pattern: '*.{fasta}'

                input:
                    file(reads) from pOTU_aaDiamond_ch

                output:
                file("*.fasta") into ( pOTU_labeledAA )
                tuple file("*phyloseqObject.csv"), file("*summaryTable.tsv"), file("*dmd.out") into summary_potuaadiamond
                file("*_summary_for_plot.csv") into taxplot4

                script:
                    """
                    cp ${params.mypwd}/bin/rename_seq.py .
                    virdb=${params.mypwd}/DBs/diamonddb_custom/${params.dbname}
                    grep ">" \${virdb} >> headers.list
                    headers="headers.list"
                    name=\$(ls ${reads} | awk -F ".fasta" '{print \$1}')
                    diamond blastp -q ${reads} -d \${virdb} -p ${task.cpus} --min-score 50 --more-sensitive -o "\$name"_dmd.out -f 6 qseqid qlen sseqid qstart qend qseq sseq length qframe evalue bitscore pident btop --max-target-seqs 1
                    echo "Preparing lists to generate summary .csv's"
                    echo "[Best hit accession number]" >access.list
                    echo "[pOTU sequence length]" >length.list
                    echo "[e-value]" >evalue.list
                    echo "[Bitscore]" >bit.list
                    echo "[Percent ID (aa)]" >pid.list
                    echo "[pOTUaa#]" >otu.list
                    echo "[Virus ID]" >"\$name"_virus.list
                    echo "[Gene]" >"\$name"_genes.list
                    grep ">" ${reads} | awk -F ">" '{print \$2}' > seqids.lst
                    echo "extracting genes and names"
                    touch new_"\$name"_headers.txt
                    j=1
                    for s in \$(cat seqids.lst);do
                        echo "Checking for \$s hit in diamond output"
                            if [[ ${params.refseq} == "T" ]];then
                                echo "RefSeq headers specified"
                                if [[ "\$(grep -wc "\$s" "\$name"_dmd.out)" -eq 1 ]];then
                                    echo "Yep, there was a hit for \$s"
                                    echo "Extracting the information now:"
                                    acc=\$(grep -w "\$s" "\$name"_dmd.out | awk '{print \$3}')
                                    echo "\$s" >> otu.list
                                    echo "\$acc" >> access.list
                                    line="\$(grep -w "\$s" "\$name"_dmd.out)"
                                    echo "\$line" | awk '{print \$10}' >>evalue.list
                                    echo "\$line" | awk '{print \$11}' >>bit.list
                                    echo "\$line" | awk '{print \$12}' >>pid.list
                                    echo "\$line" | awk '{print \$2}' >>length.list
                                    echo "Extracting virus and gene ID for \$s now"
                                    gene=\$(grep -w "\$acc" "\$headers" | awk -F "." '{ print \$2 }' | awk -F "[" '{ print \$1 }' | awk -F " " print substr(\$0, index(\$0,\$2)) | sed 's/ /_/g') &&
                                    echo "\$gene" | sed 's/_/ /g' >> "\$name"_genes.list
                                    virus=\$(grep -w "\$acc" "\$headers" | awk -F "[" '{ print \$2 }' | awk -F "]" '{ print \$1 }'| sed 's/ /_/g')
                                    echo "\$virus" | sed 's/_/ /g' >> "\$name"_virus.list
                                    echo ">pOTUaa\${j}_"\$virus"_"\$gene"" >> new_"\$name"_headers.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                else
                                    echo "Ugh, there was no hit for \$s .."
                                    echo "We still love \$s though and we will add it to the final fasta file"
                                    echo "\$s" >> otu.list
                                    echo "NO_HIT" >>access.list
                                    echo "NO_HIT" >>"\$name"_genes.list
                                    echo "NO_HIT" >>"\$name"_virus.list
                                    echo "NO_HIT" >>evalue.list
                                    echo "NO_HIT" >>bit.list
                                    echo "NO_HIT" >>pid.list
                                    echo "NO_HIT" >>length.list
                                    virus="NO"
                                    gene="HIT"
                                    echo ">pOTUaa\${j}_"\$virus"_"\$gene"" >> new_"\$name"_headers.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                            fi
                            else
                                echo "Using RVDB headers."
                                if [[ "\$(grep -wc "\$s" "\$name"_dmd.out)" -eq 1 ]];then
                                    echo "Yep, there was a hit for \$s"
                                    echo "Extracting the information now:"
                                    acc=\$(grep -w "\$s" "\$name"_dmd.out | awk '{print \$3}' | awk -F "|" '{print \$3}')
                                    echo "\$s" >>otu.list
                                    echo "\$acc" >>access.list
                                    line="\$(grep -w "\$s" "\$name"_dmd.out)"
                                    echo "\$line" | awk '{print \$10}' >>evalue.list
                                    echo "\$line" | awk '{print \$11}' >>bit.list
                                    echo "\$line" | awk '{print \$12}' >>pid.list
                                    echo "\$line" | awk '{print \$2}' >>length.list
                                    echo "Extracting virus and gene ID for \$s now"
                                    gene=\$(grep -w "\$acc" "\$headers" | awk -F "|" '{ print \$6 }' | awk -F "[" '{ print \$1 }' | sed 's/ /_/g') &&
                                    echo "\$gene" | sed 's/_/ /g' >>"\$name"_genes.list
                                    virus=\$(grep -w "\$acc" "\$headers" | awk -F "|" '{ print \$6 }' | awk -F "[" '{ print \$2 }' | awk -F "]" '{print \$1}' | sed 's/ /_/g') &&
                                    echo "\$virus" | sed 's/_/ /g' >>"\$name"_virus.list
                                    echo ">pOTUaa\${j}_"\$virus"_"\$gene"" >>new_"\$name"_headers.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                else
                                    echo "Ugh, there was no hit for \$s .."
                                    echo "We still love \$s though and we will add it to the final fasta file"
                                    echo "\$s" >>otu.list
                                    echo "NO_HIT" >>access.list
                                    echo "NO_HIT" >>"\$name"_genes.list
                                    echo "NO_HIT" >>"\$name"_virus.list
                                    echo "NO_HIT" >>evalue.list
                                    echo "NO_HIT" >>bit.list
                                    echo "NO_HIT" >>pid.list
                                    echo "NO_HIT" >>length.list
                                    virus="NO"
                                    gene="HIT"
                                    echo ">pOTUaa\${j}_\${virus}_\${gene}" >>new_"\$name"_headers.txt
                                    j=\$((\$j+1))
                                    echo "\$s done."
                                fi
                            fi
                    echo "Done with \$s"
                    done
                    echo "Now editing "\$name" fasta headers"
                    ###### rename_seq.py
                    ./rename_seq.py ${reads} new_"\$name"_headers.txt "\$name"_wTax.fasta
                    awk 'BEGIN {RS=">";FS="\\n";OFS=""} NR>1 {print ">"\$1; \$1=""; print}' "\$name"_wTax.fasta > "\$name"_tmpssasv.fasta
                    echo "[Sequence header]" > newnames.list
                    cat new_"\$name"_headers.txt >> newnames.list
                    touch sequence.list
                    awk 'BEGIN{RS=">";ORS=""}{print \$2"\\n"}' \${name}_tmpssasv.fasta >>sequence.list
                    rm "\$name"_tmpssasv.fasta
                    paste -d "," sequence.list "\$name"_virus.list "\$name"_genes.list otu.list newnames.list length.list bit.list evalue.list pid.list access.list >> "\$name"_summary_phyloseqObject.csv
                    paste -d"\\t" otu.list access.list "\$name"_virus.list "\$name"_genes.list sequence.list length.list bit.list evalue.list pid.list >> "\$name"_summaryTable.tsv
                    for x in *phyloseqObject.csv;do
                        echo "\$x"
                        lin=\$(( \$(wc -l \$x | awk '{print \$1}')-1))
                        tail -"\$lin" \$x | awk -F "," '{print \$2}' > tmpcol.list;
                        sed 's/ /_/g' tmpcol.list > tmp2col.list;
                        cat tmp2col.list | sort | uniq -c | sort -nr | awk '{print \$2","\$1}' > \${name}_summary_for_plot.csv;
                        rm tmpcol.list tmp2col.list
                    done
                    rm evalue.list ; rm sequence.list ; rm bit.list ; rm pid.list ; rm length.list seqids.lst headers.list otu.list ;
                    rm *headers.txt
                    rm "\$name"_virus.list
                    rm "\$name"_genes.list
                    rm newnames.list
                    rm access.list
                    echo "Done Assigning Taxonomy To : ${reads} "
                    """
                }
            }

        if (!params.skipPhylogeny) {

            process pOTU_Protein_Phylogeny {

                label 'norm_cpus'

                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Aminoacid/Phylogeny/Alignment", mode: "copy", overwrite: true, pattern: '*aln.*'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Aminoacid/Phylogeny/ModelTest", mode: "copy", overwrite: true, pattern: '*.tree'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Aminoacid/Phylogeny/ModelTest", mode: "copy", overwrite: true, pattern: '*aln*log'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Aminoacid/Phylogeny/Modeltest", mode: "copy", overwrite: true, pattern: '*model.summary'
                publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Aminoacid/Phylogeny/RAxML", mode: "copy", overwrite: true, pattern: '*raxml*'

    	        input:
                    file(prot) from pOTU_aaMafft_ch

                output:
                    tuple file("*_aln.fasta"), file("*_aln.html"), file("*.tree"), file("*.log"), file("*raxml*"), file("*model.summary") into pOTU_protein_phylogeny_results

                script:
                    """
                    pre=\$( echo ${prot}  | awk -F ".fasta" '{print \$1}' )
                    mafft --maxiterate 5000 --auto ${prot} >\${pre}_ALN.fasta
                    trimal -in \${pre}_ALN.fasta -out \${pre}_aln.fasta -keepheader -fasta -automated1 -htmlout \${pre}_aln.html

                    # pOTU_Protein_ModelTest
                    modeltest-ng -i ${prot} -p ${task.cpus} -d aa -s 203 --disable-checkpoint
                    echo "Modeltest analysis complete :)"
                    echo "Modeltest-ng results summary:" > \${pre}_model.summary
                    tail -7 \${pre}_aln.fasta.log >> \${pre}_model.summary

                    # pOTU_Protein_Phylogeny
                    if [ "${params.ptraxcust}" != "" ];then
                        raxml-ng --all --msa \${pre}_aln.fasta --prefix \${pre} --threads ${task.cpus} ${params.ptraxcust}
                    elif [ "${params.ptmodeltrax}" != "" ];then
                        mod=\$(tail -14 \${pre}_aln.fasta.log| head -1 | awk -F "--model " '{print \$2}')
                        raxml-ng --all --msa \${pre}_aln.fasta --model \${mod} --seed 2 --blopt nr_safe --threads ${task.cpus} --tree \${pre}_aln.fasta.raxml.startTree --bs-trees autoMRE --prefix \${pre} --redo
                    else
                        raxml-ng --all --msa \${pre}_aln.fasta --model protGTR --seed 2 --blopt nr_safe --threads ${task.cpus} --tree \${pre}_aln.fasta.raxml.startTree --bs-trees autoMRE --prefix \${pre} --redo
                    fi
                    """
            }
        }

        process Generate_pOTU_Protein_Counts {

            label 'norm_cpus'

            publishDir "${params.mypwd}/${params.outdir}/Analyses/pOTU/Aminoacid/Counts", mode: "copy", overwrite: true

            input:
                file(fasta) from pOTU_aaCounts_ch
                file(merged) from mergeforpOTUaacounts
                file(samplist) from samplistpotu

            output:
                tuple file("*_counts.csv"), file("*dmd.out") into potuaacounts_summary

            script:
                """
                set +e
                potu="\$( echo ${fasta} | awk -F "_" '{print \$3}')"
                diamond makedb --in ${fasta} --db ${fasta}
                diamond blastx -q ${merged} -d ${fasta} -p ${task.cpus} --min-score ${params.ProtCountsBit} --id ${params.ProtCountID} -l ${params.ProtCountsLength} --more-sensitive -o ${params.projtag}_\${potu}_Counts_dmd.out -f 6 qseqid qlen sseqid qstart qend qseq sseq length qframe evalue bitscore pident btop --max-target-seqs 1 --max-hsps 1
                echo "[Sequence]" >tmp.col1.txt
                echo "Generating sample id list"
                grep ">" ${fasta} | awk -F ">" '{print \$2}' | sort | uniq > otuid.list
                cat otuid.list >> tmp.col1.txt
                echo "Beginning them counts tho my g"
                for y in \$( cat ${samplist} );do
                    echo "Starting with \$y now ..."
                    grep "\$y" ${params.projtag}_\${potu}_Counts_dmd.out > tmp."\$y".out
                    echo "Isolated hits"
                    echo "Created uniq subject id list"
                    echo "\$y" > "\$y"_col.txt
                    echo "Starting my counts"
                    for z in \$(cat otuid.list);do
                        echo "Counting \$z hits"
        	            echo "grep -wc "\$z" >> "\$y"_col.txt"
        	            grep -wc "\$z" tmp."\$y".out >> "\$y"_col.txt
    		            echo "\$z counted"
    	            done
               done
               paste -d "," tmp.col1.txt *col.txt > ${params.projtag}_\${potu}_counts.csv
               rm tmp*
               rm *col.txt
               """
           }
    }

} else {
	println("\n\t\033[0;31mMandatory argument not specified. For more info use `nextflow run vAMPirus.nf --help`\n\033[0m")
	exit 0
}


if (params.generateAAcounts) {

    if (params.proteinFasta && params.mergedFast && params.sampleList) {

        process Generate_Protein_Counts {

            label 'norm_cpus'

            publishDir "${params.mypwd}/${params.outdir}/Analyses/ProteinCounts", mode: "copy", overwrite: true

            output:
                tuple file("*_counts.csv"), file("*dmd.out") into potuaacounts_summary

            script:
                """
                set +e
                potu="\$( echo ${params.proteinFasta} | awk -F "_" '{print \$3}')"
                diamond makedb --in ${params.proteinFasta} --db ${params.proteinFasta}
                diamond blastx -q ${params.mergedFast} -d ${params.proteinFasta} -p ${task.cpus} --min-score ${params.ProtCountsBit} --id ${params.ProtCountID} -l ${params.ProtCountsLength} --more-sensitive -o ${params.projtag}_\${potu}_Counts_dmd.out -f 6 qseqid qlen sseqid qstart qend qseq sseq length qframe evalue bitscore pident btop --max-target-seqs 1 --max-hsps 1
                echo "[Sequence]" >tmp.col1.txt
                echo "Generating sample id list"
                grep ">" ${params.proteinFasta} | awk -F ">" '{print \$2}' | sort | uniq > otuid.list
                cat otuid.list >> tmp.col1.txt
                echo "Beginning them counts tho my g"
                for y in \$( cat ${params.sampleList} );do
                    echo "Starting with \$y now ..."
                    grep "\$y" ${params.projtag}_\${potu}_Counts_dmd.out > tmp."\$y".out
                    echo "Isolated hits"
                    echo "Created uniq subject id list"
                    echo "\$y" > "\$y"_col.txt
                    echo "Starting my counts"
                    for z in \$(cat otuid.list);do
                        echo "Counting \$z hits"
                        echo "grep -wc "\$z" >> "\$y"_col.txt"
                        grep -wc "\$z" tmp."\$y".out >> "\$y"_col.txt
                        echo "\$z counted"
                    done
               done
               paste -d "," tmp.col1.txt *col.txt > ${params.projtag}_\${potu}_counts.csv
               rm tmp*
               rm *col.txt
               """
           }
    } else {
        println("\n\t\033[0;31mProvide PATH for `proteinFasta` and `mergedFast`\n\033[0m")
        exit 0
    }
}

if (params.dataCheck) {

    println("\n\tRunning vAMPirus \n")

    if (!params.skipFastQC) {

        process QualityCheck_1DC {

            label 'low_cpus'

            tag "${sample_id}"

            publishDir "${params.mypwd}/${params.outdir}/DataCheck/ReadProcessing/FastQC/PreClean", mode: "copy", overwrite: true

            input:
                tuple sample_id, file(reads) from reads_qc_ch

            output:
                tuple sample_id, file("*_fastqc.{zip,html}") into fastqc_results_OAS

            script:
                """
                fastqc --quiet --threads $task.cpus $reads
                """
        }
    }

    if (!params.skipFastP) {

        process Adapter_Removal_DC {

            label 'low_cpus'

            tag "${sample_id}"

            publishDir "${params.mypwd}/${params.outdir}/DataCheck/ReadProcessing/AdapterRemoval", mode: "copy", overwrite: true, pattern: "*.fastp.{json,html}"

            input:
                tuple sample_id, file(reads) from reads_ch

            output:
                tuple sample_id, file("*.fastp.{json,html}") into fastp_results
                tuple sample_id, file("*.filter.fq") into reads_fastp_ch
                tuple sample_id, file("*.csv") into fastp_csv_DC

            script:
                """
                echo ${sample_id}

                fastp -i ${reads[0]} -I ${reads[1]} -o left-${sample_id}.filter.fq -O right-${sample_id}.filter.fq --detect_adapter_for_pe \
                --average_qual 25 -c --overrepresentation_analysis --html ${sample_id}.fastp.html --json ${sample_id}.fastp.json --thread ${task.cpus} \
                --report_title ${sample_id}

                bash get_readstats.sh ${sample_id}.fastp.json
                """
            }

    } else {
        reads_ch
            .set{ reads_fastp_ch }
        fastp_results = Channel.empty()
    }

    if (!params.skipBBduk) {

        process Primer_Removal_DC {

            label 'low_cpus'

            tag "${sample_id}"

            publishDir "${params.mypwd}/${params.outdir}/DataCheck/ReadProcessing/PrimerRemoval", mode: "copy", overwrite: true

            input:
                tuple sample_id, file(reads) from reads_fastp_ch

            output:
                tuple sample_id, file("*bbduk*.fastq.gz") into ( reads_bbduk_ch, readsforqc2 )

            script:
                // check if we need to check this outside processes
                if ( params.fwd == "" && params.rev == "" ) {
                    """
                    bbduk.sh in1=${reads[0]} out=${sample_id}_bb_R1.fastq.gz ftl=${params.FTRIM} t=${task.cpus}
                    bbduk.sh in=${reads[1]} out=${sample_id}_bb_R2.fastq.gz ftl=${params.RTRIM} t=${task.cpus}
    		        repair.sh in1=${sample_id}_bb_R1.fastq.gz in2=${sample_id}_bb_R2.fastq.gz out1=${sample_id}_bbduk_R1.fastq.gz out2=${sample_id}_bbduk_R2.fastq.gz outs=sing.fq repair
                    """
                } else if ( params.GlobTrim && !params.GlobTrim == "" ) {
                    """
                    FTRIM=\$( echo ${GlobTrim} | cut -f 1 -d "," )
                    RTRIM=\$( echo ${GlobTrim} | cut -f 2 -d "," )
                    bbduk.sh in=${reads[0]} out=${sample_id}_bb_R1.fastq.gz ftl=\${FTRIM} t=${task.cpus}
                    bbduk.sh in=${reads[1]} out=${sample_id}_bb_R2.fastq.gz ftl=\${RTRIM} t=${task.cpus}
    		        repair.sh in1=${sample_id}_bb_R1.fastq.gz in2=${sample_id}_bb_R2.fastq.gz out1=${sample_id}_bbduk_R1.fastq.gz out2=${sample_id}_bbduk_R2.fastq.gz outs=sing.fq repair
                    """
                } else {
                    """
                    bbduk.sh in=${reads[0]} in2=${reads[1]} out=${sample_id}_bbduk_R1.fastq.gz out2=${sample_id}_bbduk_R2.fastq.gz literal=${params.fwd},${params.rev} copyundefined=t t=${task.cpus} restrictleft=25 k=12 ordered=t mink=2 ktrim=l ecco=t rcomp=t minlength=200 tbo tpe
                    """
                }
    	  }
    } else {
        reads_fastp_ch
            .set{ reads_bbduk_ch }
    }

    if (!params.skipFastQC) {

        process QualityCheck_2_DC {

            label 'low_cpus'

            tag "${sample_id}"

            publishDir "${params.mypwd}/${params.outdir}/DataCheck/ReadProcessing/FastQC/PostClean", mode: "copy", overwrite: true

            input:
                tuple sample_id, file(reads) from readsforqc2

            output:
                tuple sample_id, file("*_fastqc.{zip,html}") into fastqc2_results_OAS

            script:
                """
                fastqc --quiet --threads $task.cpus $reads
                """
        }
    }

    process Read_Merging_DC {

        label 'norm_cpus'

        tag "${sample_id}"

        publishDir "${params.mypwd}/${params.outdir}/DataCheck/ReadProcessing/ReadMerging_DC", mode: "copy", overwrite: true

        input:
            tuple sample_id, file(reads) from reads_bbduk_ch

        output:
            file("*_mergered.fq") into reads_vsearch1_ch
            file("*.name") into names

        script:
            """
            vsearch --fastq_mergepairs ${reads[0]} --reverse ${reads[1]} --threads ${task.cpus} --fastqout ${sample_id}_mergered.fq --fastq_maxee 1 --relabel ${sample_id}.
            echo ${sample_id} > ${sample_id}.name
            """

    }

    process Compile_Reads_DC {

        label 'low_cpus'

        publishDir "${params.mypwd}/${params.outdir}/DataCheck/ReadProcessing/ReadMerging_DC", mode: "copy", overwrite: true

        input:
            file(reads) from reads_vsearch1_ch
                .collect()

        output:
            file("*_clean_merged_reads.fastq") into collect_samples_ch

        script:
            """
            cat ${reads} >>${params.projtag}_clean_merged_reads.fastq
	        """
    }

    process Compile_Names_DC {

        label 'low_cpus'

        publishDir "${params.mypwd}/${params.outdir}/DataCheck/ReadProcessing/ReadMerging_DC", mode: "copy", overwrite: true

        input:
            file(names) from names
                .collect()

        output:
            file("*sample_ids.list") into ( samplelist, samplistpotu )

        script:
            """
            cat ${names} >>${params.projtag}_sample_ids.list
            """

    }

    process Length_Filtering_DC {

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/DataCheck/ReadProcessing/LengthFiltering_DC", mode: "copy", overwrite: true

        input:
            file(reads) from collect_samples_ch

        output:
        file("*_merged_clean_Lengthfiltered.fastq") into reads_vsearch2_ch

        script:
            """
            ##histogram generation
            bbduk.sh in=${reads} bhist=${params.projtag}_all_merged_prelenFilt_bhist.txt qhist=${params.projtag}_all_merged_prelenFilt_qhist.txt gchist=${params.projtag}_all_merged_prelenFilt_gchist.txt aqhist=${params.projtag}_all_merged_prelenFilt_aqhist.txt lhist=${params.projtag}_all_merged_prelenFilt_lhist.txt gcbins=auto
            ##Trimming and lower length filtering
            fastp -i ${reads} -o ${params.projtag}_merged_reads_clean.fastq -b ${params.maxLen} -l ${params.minLen} --thread ${task.cpus} -n 1
            ##Reformat to fasta for counts
            reformat.sh in=${params.projtag}_merged_reads_clean.fastq out=${params.projtag}_merged_clean.fasta t=${task.cpus}
            bbduk.sh in=${params.projtag}_merged_reads_clean.fastq  out=${params.projtag}_merged_clean_Lengthfiltered.fastq minlength=${params.maxLen} maxlength=${params.maxLen} t=${task.cpus}
            bbduk.sh in=${params.projtag}_merged_clean_Lengthfiltered.fastq bhist=${params.projtag}_all_merged_postlenFile_bhist.txt qhist=${params.projtag}_all_merged_postlenFile_qhist.txt gchist=${params.projtag}_all_merged_postlenFile_gchist.txt aqhist=${params.projtag}_all_merged_postlenFile_aqhist.txt lhist=${params.projtag}_all_merged_postlenFile_lhist.txt gcbins=auto
            """
        }

    process Extract_Uniques_DC {

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/DataCheck/ReadProcessing/Uniques", mode: "copy", overwrite: true

        input:
            file(reads) from reads_vsearch2_ch

        output:
            file("all_unique_seq.fasta") into reads_vsearch3_ch

        script:
            """
            vsearch --derep_fulllength ${reads} --sizeout --relabel_keep --output all_unique_seq.fasta
            """
    }

    process Identify_ASVs_DC {

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/DataCheck/ReadProcessing/Uniques/asvs/wchimeras", mode: "copy", overwrite: true

        input:
            file(reads) from reads_vsearch3_ch

        output:
            file("asv_chim.fasta") into reads_vsearch4_ch

        script:
            """
            vsearch --cluster_unoise ${reads} --unoise_alpha ${params.alpha} --relabel ASV --centroids asv_chim.fasta --minsize ${params.minSize}
            """
    }

    process Chimera_Removal_DC {

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/DataCheck/Clustering/ASVs", mode: "copy", overwrite: true

        input:
            file(reads) from reads_vsearch4_ch

        output:
            file("*ASVs_all.fasta") into ( reads_vsearch5_ch, nucl2aa, asvsforAminotyping, asvfastaforcounts, asvaminocheck )

        script:
            """
	        vsearch --uchime3_denovo asv_chim.fasta --relabel ASV --nonchimeras ${params.projtag}_ASVs_all.fasta
            """
    }

    process NucleotideBased_ASV_clustering_DC {

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/DataCheck/Clustering/nOTU", mode: "copy", overwrite: true, pattern: '*ASVs_all.fasta'

        input:
            file(fasta) from reads_vsearch5_ch

        output:
            tuple file("*_otu*.fasta"), file("*ASV_all.fasta") into nuclFastas_forDiamond_ch
            file("*_otu*.fasta") into ( fileforMafft, nuclFastas_forMatrix_ch )

        script:
        if (params.datacheckntIDlist) {
            """
            for id in `echo ${params.datacheckntIDlist} | tr "," "\n"`;done
                vsearch --cluster_fast ${fasta} --centroids ${params.projtag}_otu\${id}.fasta --threads ${task.cpus} --relabel OTU --id \${id}
            done
            cp ${fasta} ${params.projtag}_ASV_all.fasta
            """
        }
    }

    process Translation_For_ProteinBased_Clustering_DC {

        label 'norm_cpus'

        conda 'python=2.7'

        publishDir "${params.mypwd}/${params.outdir}/Clustering/pOTU/translation", mode: "copy", overwrite: true

        input:
            file(fasta) from nucl2aa

        output:
            file("*ASVprotforclust.fasta") into clustering_aa
            file("*_translation_report") into reportaa_VR
            file("*_ASV_all.fasta") into asvfastaforaaclust

        script:
            """
            ${tools}/virtualribosomev2/dna2pep.py ${fasta} -r all -x -o none --fasta ${params.projtag}_ASVprotforclust.fasta --report ${params.projtag}_translation_report
            """
    }

    process Protein_clustering_DC {

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/Clustering/pOTU", mode: "copy", overwrite: true

        input:
            file(fasta) from clustering_aa
            file(asvs) from asvfastaforaaclust

        output:
            file("${params.projtag}_nucleotides_pOTU*.fasta") into pOTU_fastas
            file("${params.projtag}_aminos_pOTU*_noTaxonomy.fasta") into ( pOTUaa_notlabeled_fasta )

        script:
        // add awk script to count seqs
            """
            cp ${params.mypwd}/bin/rename_seq.py .
            for id in `echo ${params.datacheckaaIDlist} | tr "," "\n"`;do
                awk 'BEGIN{RS=">";ORS=""}length(\$2)>${params.minAA}{print ">"\$0}' ${fasta} >${params.projtag}_filtered_proteins.fasta
                cd-hit -i ${params.projtag}_filtered_proteins.fasta -c \${id} -o ${params.projtag}_pOTU\${id}.fasta
                sed 's/>Cluster />Cluster_/g' ${params.projtag}_pOTU\${id}.fasta.clstr >${params.projtag}_pOTU\${id}.clstr
                rm ${params.projtag}_pOTU\${id}.fasta.clstr
                grep ">Cluster_" ${params.projtag}_pOTU\${id}.clstr >temporaryclusters.list
                for x in \$(cat temporaryclusters.list);do
                    echo "Extracting \$x"
                    name=\$( echo \$x | awk -F ">" '{print \$2}')
                    sed -n "/\$name/,/Cluster_/p" ${params.projtag}_pOTU\${id}.clstr > "\$name"_tmp.list
                done
                j=1
                for x in *_tmp.list;do
                    name=\$(echo \$x | awk -F "_tmp" '{print \$1}')
                    cluster="pOTU\${j}"
                    grep "ASV" \$x | awk -F ", " '{print \$2}' | awk -F "_" '{print \$1}' | awk -F ">" '{print \$2}' > seqs_tmps.list
                    seqtk subseq ${asvs} seqs_tmps.list > \${cluster}_nucleotide_sequences.fasta
                    vsearch --cluster_fast \${cluster}_nucleotide_sequences.fasta --id 0.2 --centroids \${name}_centroids.fasta
                    grep ">" \${name}_centroids.fasta >> tmp_centroids.list
                    u="1"
                    for y in \$( cat tmp_centroids.list);do
                        echo ">\${cluster}_type"\$u"" >> tmp_centroid.newheaders
                        u=\$(( \$u+1 ))
                    done
                    ./rename_seq.py \${name}_centroids.fasta tmp_centroid.newheaders \${cluster}_types_labeled.fasta
                    j=\$(( \$j+1 ))
                done
                cat *_types_labeled.fasta >> ${params.projtag}_nucleotides_pOTU\${id}.fasta
                grep -w "*" ${params.projtag}_pOTU\${id}.clstr | awk '{print \$3}' | awk -F "." '{print \$1}' >tmphead.list
                grep -w "*" ${params.projtag}_pOTU\${id}.clstr | awk '{print \$2}' | awk -F "," '{print \$1}' >tmplen.list
                paste -d"," temporaryclusters.list tmphead.list >tmp.info.csv
                grep ">" ${params.projtag}_pOTU\${id}.fasta >lala.list
                j=1
                for x in \$(cat lala.list);do
                    echo ">${params.projtag}_pOTU\${j}" >>${params.projtag}_aminoheaders.list
                    echo "\${x},>${params.projtag}_pOTU\${j}" >>tmpaminotype.info.csv
                    j=\$(( \$j+1 ))
                done
                rm lala.list
                awk -F "," '{print \$2}' tmp.info.csv >>tmporder.list
                for x in \$(cat tmporder.list);do
                    grep -w "\$x" tmpaminotype.info.csv | awk -F "," '{print \$2}' >>tmpder.list
                done
                paste -d "," temporaryclusters.list tmplen.list tmphead.list tmpder.list >${params.projtag}_pOTUCluster_summary.csv
                rm tmp*
                ./rename_seq.py ${params.projtag}_pOTU\${id}.fasta ${params.projtag}_aminoheaders.list ${params.projtag}_aminos_pOTU\${id}_noTaxonomy.fasta
                stats.sh in=${params.projtag}_aminos_pOTU\${id}_noTaxonomy.fasta gc=${params.projtag}_clustered.gc gcformat=4
                awk 'BEGIN{RS=">";ORS=""}length(\$2)<${params.minAA}{print ">"\$0}' ${fasta} >${params.projtag}_problematic_translations.fasta
                if [ `wc -l ${params.projtag}_problematic_translations.fasta | awk '{print \$1}'` -gt 1 ];then
                    grep ">" ${params.projtag}_problematic_translations.fasta | awk -F ">" '{print \$2}' > problem_tmp.list
                    seqtk subseq ${asvs} problem_tmp.list > ${params.projtag}_problematic_nucleotides.fasta
                fi
                done
            done
            """
	}
    /*process Report_DataCheck {

        label 'norm_cpus'

        publishDir "${params.mypwd}/${params.outdir}/DataCheck/Report", mode: "copy", overwrite: true, pattern: '*ASVs_all.fasta'

        input:
            file(fasta) from reads_vsearch5_ch

        output:
            tuple file("*_otu*.fasta"), file("*ASV_all.fasta") into ( nuclFastas_forDiamond_ch, nuclFastas_forCounts_ch )
            file("*_otu*.fasta") into ( fileforMafft, nuclFastas_forMatrix_ch )

        script:
            """
            echo "Report"
            """
    }*/
}

workflow.onComplete {
    log.info ( workflow.success ? \
        "---------------------------------------------------------------------------------" \
        + "\n\033[0;32mDone! Open the following report in your browser --> ${params.outdir}/${params.tracedir}/vampirus_report.html\033[0m" : \
        "---------------------------------------------------------------------------------" \
        + "\n\033[0;31mSomething went wrong. Check error message below and/or log files.\033[0m" )
}
