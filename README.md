ribiosScripts: Rscripts associated with the ribios suite
===

This repository contains Rscripts as command-line tools, written with ribios R packages. A Docker image is stored under the GitHub package registry.


## Available Ribios Scripts

All scripts are written in R using the ribios packages.


### bioqc.Rscript

```
Usage: Run BioQC algorithm with expression data

bioqc.Rscript -infile FILE [-featuretype TYPE] [-outfile FILE] [-threshold VAL] [-gmt FILE] [-appendGmtDesc] [-alternative ALT] [-log FILE]

Mandatory parameters:
  -infile FILE  Gene expression in GCT or ChipFetcher format

  -gmt FILE     Use specified GMT file other than the tissue marker genes provided by the package
Commonly used optional parameters:
  -outfile FILE Output file name. Writing to standard output if missing
  -log FILE: write log file. If missing, no logging takes place. Set to '-' will direct loggings to stdout.
Less commonly used optional parameters:
  -alternative ALT      One of the following: greater, less, two.sided
  -featuretype TYPE     Feature type supported by GTI. Needed for GCT files
                Accepts all GTI supported chip types, and 'GeneID', 'Ensembl', 'RefSeq', 
                'GeneSymbol', or 'any' (case insensitive)
                Setting 'GeneSymbol' will assume that input features are human gene symbols.
                 If same type of features are used in the GMT and GCT files, use the parameter 'AsIs'.
                If missing, input features are assumed to be probesets and the annotation is done automatically
  -threshold NUM        Significance level significance. Signatures without any significant hits are removed. 
                The threshold is given by -log10(p). For example: -threshold 3 filters p>0.001.
  -appendGmtDesc        Append description line to GMT gene list names.
```

### biosHeatmap.Rscript

```
Usage: biosHeatmap.Rscript -infile infile1 [infile2] [...] -outfile outfile1 [outfile2] [...] OPTS

 OPTS can be one or more of following optional parameters:
 # data scaling
         [-scale none/row/column] [-transpose]
 # hierarhical clustering, dendrogram and displaying order
         [-noRowv] [-noColv] [-dendrogram both/row/column/none] [-dist FUN] [-hclust FUN] [-symm] [-revC]
 # colors and mapping of colors
         [-zlimLo zlimLo] [-zlimHi zlimHi] [-colors COLS] [-naColor COL] [-symbreaks auto/true/false]
 # Title and labels
         [-main MAIN] [-xlab XLAB] [-ylab YLAB] [-cexRow VAL] [-cexCol VAL] [-colorKeyTitle TITLE]
 # layout
         [-width VAL] [-height VAL] [-margins colMargin rowMargin] [-lhei heightKey heightMap]
```

### collapseExprsMatByChip.Rscript

```
Usage: Collapse any GCT/tab-delimited files given a chip file

collapseExprsMatByChip.Rscript -infile FILE -chipfile FILE [-outfile FILE] [-stat maxMean] [-useChipfileAnno]

Mandoary parameters:
  -infile: Input gct or tab-delimited file
  -chipfile: A tab-delimited file with three columns (with header):
             Feature, GeneSymbol, Description

Optional parameters:
  -outfile: Output file. If omitted, written to standard output
  -stat: Statistics used to collapse features that map to the same GeneSymbol.
         Possible options are:
         maxMean: The feature with the maximal mean expression value is chosen.
  -useChipfileAnno: By default the output GCT uses NAME and DESCRIPTION columns of the 
                    input gct/tsv file.
                    If given, then GeneSymbol (or whatever identifiers in the second column) 
                    and Description in chip file are used.
```

### plotPCA.Rscript

```
Usage: Plot the sample relations based on PCA (principal component analysis)

plotPCA.Rscript -infile FILE [-outfile FILE] [-cls FILE] [-outRfile FILE] [-outTable FILE] [-log FILE]

Mandatory options:
  -infile: Input file in gct or tsv format, containing *normalized expression values*
Optional parameters
  -outfile: Output plot file. Image format will be determined by the file suffix
            E.g. abc.png produces PNG file, and abc.pdf produces PDF file. PDF is the default
            If missing, the file name will be derived from the infile
  -cls: Sample annotation in the CLS format, matching the GCT file.
         If provided, samples are colored in the plot by the group
  -scale: scale the data before running the PCA algorithm
  -outRfile: Output RData file, containing the data objects.
  -outTable: Output tab-delimited file containing COA coordinates.
  -choices: Which principal components are plotted? In the format of X,Y. Default is 1,2
  -log FILE: write log into file. Use '-log -' to write log to the standard output.
```

## Singularity image

Brief description how to pull and use a Singularity image from the GitHub Package registry containing the Docker image for this repository.

Authentification by token may not be required because this repository is currently "public".

### 1. Create "read package" token in github repo

First, create a new token with the ability to "read packages", e.g. valid for 30 days.
Store the token at a secure place.


### 2. Singularity remote login

Next, in a terminal with Singularity login to GitHub's OCI/Docker registry using the token.

```bash
singularity remote login --username <user_id> docker://ghcr.io
```

Enter the token upon request. Most probably this step needs to be done only once.
This returns the message `Token stored in /home/<user_id>/.singularity/remote.yaml`,
and it creates also a file `/home/<user_id>/.singularity/docker-config.json`

Alternatively, one can set the required environment variables

```bash
export SINGULARITY_DOCKER_USERNAME=<username>
export SINGULARITY_DOCKER_PASSWORD=<read-packages token>

singularity run docker://ghcr.io/bedapub/ribiosscripts:main R
```

### 3. Pull or run the image

Finally, use the Singularity image from the remote registry by applying `pull`, `run`, or `exec`

```bash
singularity run docker://ghcr.io/bedapub/ribiosscripts:main R
```

### Content of the Docker image

List of R packages that are, amongst others, installed in the Docker image
- ComplexHeatmap
- fgsea
- Vennerable
- bedapub/ribiosArg
- bedapub/ribiosUtils
- bedapub/ribiosIO
- bedapub/ribiosAnnotation
- bedapub/ribiosExpression
- bedapub/ribiosNGS
- bedapub/ribiosMath
- bedapub/ribiosPlot
- bedapub/ribiosGSEA
