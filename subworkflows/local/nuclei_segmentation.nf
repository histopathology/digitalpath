//
// Extract patches and segment nuclei using hovernet
//

include { TILE_EXTRACTOR   } from '../../modules/local/tile_extractor'
include { HOVERNET         } from '../../modules/local/hovernet'

workflow NUCLEI_SEGMENTATION {
    take:
    slide_with_qc_mask

    main:
    TILE_EXTRACTOR (
        slide_with_qc_mask,
        params.tile_size,
	params.extraction_mag
    )
    HOVERNET(
        TILE_EXTRACTOR.out.patches,
        params.hovernet_model
    )

    emit:
    patches = HOVERNET.out.hovernet_output
}
