## DIGIPATH: a simple proof of concept pipeline for Digital Pathology using Nextflow

This small nextflow proof-of-concept pipeline is intended to illustrate the use of Nextflow in Digital Pathology. It utilizes the DSL-2
syntax.

The pipeline performs the following steps:

First Quality Control using HistoQC

Blur detection using HistoBlur

Patch extraction at the desired magnification and size

Nuclei segmentation using Hovernet


# Installation
To install the necessary dependencies, the use of anaconda is highly recommended.
The only necessary dependencies to run this pipeline are:

Nextflow,
Docker,
CUDA drivers for GPU support,
Nvidia Docker

Using conda, these tools can be installed as follows:

```
conda create --name nextflow
conda install -c bioconda nextflow
```

Once nextflow has been installed, make sure to update to the latest version:

```
nextflow self-update
```


This installation command assumes that you have Nvidia docker and CUDA [installed](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

# Preparation

Before running the pipeline you need to edit the sample sheet and add the information in the corresponding columns.
The last column is mrxs file specific and requires the data directory of the mrxs slide. For non mrxs files, you can simply add the
path to the directory where the slides are located.

For an mrxs file the sample sheet will look something like this:
```
test_mrxs,      H&E,       basename.mrxs,       /path/to/mrxs/basename.mrxs,        /path/to/mrxs/basename/
```
For other files the sample sheet will look something like this:
```
test_svs,       H&E,       basename.svs,       /path/to/svs/basename.svs,        /path/to/svs/
```
You will also need to download the hovernet model available [here](https://drive.google.com/file/d/1SbSArI3KOOWHxRlxnjchO7_MbWzB4lNR/view)

As well as a histoblur [model](https://github.com/choosehappy/HistoBlur/blob/main/pretrained_model/blur_detection_densenet_best_model_10.0X.pth)

The config file for HistoQC is provided in the assests subdirectory of this pipeline

Then, you will need to adjust the paths to the different models accordingly in the nextflow.config file.

You can also adjust the resource to use for the analysis accordingly in the "Max resource options"

# Usage

To run the pipeline, you can use the following command:

```
nextflow run main.nf --input sample_sheet.csv --outdir digipath_results -profile docker
```


