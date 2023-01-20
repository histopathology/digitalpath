process HOVERNET {
    tag "$meta.id"

    label (params.GPU == "ON" ? 'with_gpus': 'with_cpus')

    conda "conda-forge::python=3.8.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://canqx/hovernet:v5' :
        'canqx/hovernet:v5' }"


    input:
    tuple val(meta), file(patches)
    path model

    output:
    tuple val(meta), path("./${out_dir}/json/"), file(patches), emit: json
    tuple val(meta), path("./${out_dir}/overlay/"), file(patches), emit: overlay
    tuple val(meta), path("./${out_dir}/"), file(patches), emit: hovernet_output


    script:
    out_dir = "${meta.id}_hovernet"
    
    """
    python /usr/app/src/run_infer.py \\
        --gpu='0' \\
        --nr_types=6 \\
        --type_info_path='/usr/app/src/type_info.json' \\
        --batch_size=16 \\
        --model_mode=fast \\
        --model_path=${model} \\
        --nr_inference_workers=8 \\
        --nr_post_proc_workers=16 \\
        tile \\
        --input_dir=${patches} \\
        --output_dir=$out_dir \\
        --mem_usage=0.1 \\
        --draw_dot \\
        --save_qupath
    """
}