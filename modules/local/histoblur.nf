process HISTOBLUR {
    tag "$meta.id"

    label (params.GPU == "ON" ? 'with_gpus': 'with_cpus')

    conda "conda-forge::python=3.8.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://petroslk/histoblur:latest' :
        'petroslk/histoblur:latest' }"


    input:
    tuple val(meta), file(mask), file(slide), file(slide_dat)
    path model
    
    output:
    tuple val(meta), path("./${out_dir}/output_${slide.baseName}.tif"), file(slide), file(slide_dat), emit: histoblur_mask
    tuple val(meta), path("./${out_dir}/blurmask_${slide.baseName}.png"), file(slide), file(slide_dat), emit: histoblur_binmask
    tuple val(meta), path("./${out_dir}/"), emit: histoblur_results

    script:
    out_dir = "${meta.id}_histoblur"
    def args = task.ext.args ?: ''
    """
    HistoBlur detect -f ${slide} -m ${model} -o ${out_dir} -b $args
    """
}