process TILE_EXTRACTOR {
    tag "$meta.id"

    label 'process_low'

    conda "conda-forge::python=3.8.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://petroslk/histoblur:latest' :
        'petroslk/histoblur:latest' }"

    input:
    tuple val(meta), file(mask), file(slide), file(slide_dat)
    val tile_size
    val extraction_mag
    output:
    tuple val(meta), path("./${out_dir}/"), emit: patches

    script:
    out_dir = "${meta.id}_patches"
    """
    tile_maker.py ${slide} -b ${mask} -t ${tile_size} -m ${extraction_mag} -o $out_dir
    """
}
