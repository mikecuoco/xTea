
version 1.0

workflow xTea_workflow {

    input {
        String sample
        File input_bam
        File genome_tar
        File repeats_tar
        File gencode_gff

        Int nthreads = 1
        Int flag = 5907
        Int rep_type = 7
    }

    call xTea_germline_hg38 {
        input:
            sample=sample,
            input_bam=input_bam,
            repeats_tar=repeats_tar,
            genome_tar=genome_tar,

            gencode_gff=gencode_gff,
            nthreads=nthreads,
            rep_type=rep_type,
            flag=flag,
    }

}

task xTea_germline_hg38 {
    input {
        String sample
        File input_bam
        File genome_tar
        File repeats_tar
        File gencode_gff

        Int nthreads = 1
        Int flag = 5907
        Int rep_type = 7
        Int memory_mb = 3000
        Int preemptible_attempts = 3
        Int disk_size = ceil(size(input_bam, "GB") * 2) + 20 
    }
    


    command {
        python /usr/local/bin/gnrt_pipeline_germline_cloud_v38.py \
        --decompress \
        --output run_jobs.sh \
        --xtea /usr/local/bin/ \
        --path . \
        --id ${sample} \
        --bam ${input_bam} \
        --ref ${genome_tar} \
        --lib ${repeats_tar} \
        --gene ${gencode_gff} \
        --cores ${nthreads} \
        --reptype ${rep_type} \
        --flag ${flag} 

        bash run_jobs.sh
    }

    runtime {
        docker: 'mcuoco/xtea_germline:latest'
        memory: "~{memory_mb} MiB"
        disks: "local-disk ${disk_size} HDD"
        preemptible: preemptible_attempts
        cpu: nthreads
    }

    output {
        Array[File] output_variable = ('${sample + "_*" + ".tar.gz"}')
    }

}

