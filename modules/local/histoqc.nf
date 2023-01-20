process HISTOQC {
    tag "$meta.id"
    label 'process_low'

    conda "conda-forge::python=3.8.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://petroslk/histoqc:latest' :
        'petroslk/histoqc:latest' }"

    input:
    tuple val(meta), file(slide), file(slide_dat)
    path config_file

    output:
    
    tuple val(meta), path("./${out_dir}/${meta.basename}/$mask_name"), file(slide), file(slide_dat), emit: histoqc_mask
    tuple val(meta), path("./${out_dir}/"), emit: histoqc_results

    script:
    out_dir = "${meta.id}_histoqc"
    mask_name = "${slide.baseName}.png"
    """
    python -m histoqc ${slide} -o $out_dir -c ${config_file}
    mv ./${out_dir}/${meta.basename}/${meta.basename}_mask_use.png ./${out_dir}/${meta.basename}/$mask_name
    """
}