//
// Verify quality of slides and return mask of regions without artefacts
//

include { HISTOQC   } from '../../modules/local/histoqc'
include { HISTOBLUR } from '../../modules/local/histoblur'


workflow QUALITY_CONTROL {
    take:
    slide

    main:
    HISTOQC(
        slide,
        params.histoqc_config
    )
    HISTOBLUR(
        HISTOQC.out.histoqc_mask,
        params.histoblur_model
    )
    emit:
    slide_qc = HISTOBLUR.out.histoblur_binmask
}