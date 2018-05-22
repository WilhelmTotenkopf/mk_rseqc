<config.mk
#This program is used to “guess” how RNA-seq sequencing were configured, particulary how reads were stranded for strand-specific RNA-seq data, through comparing the “strandness of reads” with the “standness of transcripts”.
results/%.infer_experiment.txt:	data/%.bam
	mkdir -p `dirname $target`
	infer_experiment.py \
		-i $prereq \
		-r $BED \
		> $target".build" \
	&& mv $target".build" $target
#For a given alignment file (-i) in BAM or SAM format and a reference gene model (-r) in BED format, this program will compare detected splice junctions to reference gene model. splicing annotation is performed in two levels: splice event level and splice junction level.
	junction_annotation.py \
		-i $prereq \
		-r $BED \
		-o "results/"$stem".rseqc.build" \
	&& mv"results/"$stem".rseqc.build" "results/"$stem".rseqc"
#This script determines “uniquely mapped reads” from mapping quality, which quality the probability that a read is misplaced (Do NOT confused with sequence quality, sequence quality measures the probability that a base-calling was wrong) .
	bam_stat.py \
		-i $prereq \
		> "results/"$stem".bam_stat.txt.build" \
	&& mv  "results/"$stem".bam_stat.txt.build"  "results/"$stem".bam_stat.txt" 
#This module checks for saturation by resampling 5%, 10%, 15%, ..., 95% of total alignments from BAM or SAM file, and then detects splice junctions from each subset and compares them to reference gene model.
	junction_saturation.py \
		-i $prereq \
		-r $BED \
		-o "results/"$stem".rseqc.build" \
		2>"results/"$stem".junction_annotation_log.txt.build" \
	&& mv "results/"$stem".rseqc.build"  "results/"$stem".rseqc" \
	&& mv "results/"$stem".junction_annotation_log.txt.build"  "results/"$stem".junction_annotation_log.txt" 
#This module is used to calculate the inner distance (or insert size) between two paired RNA reads. The distance is the mRNA length between two paired fragments.
	inner_distance.py \
		-i $prereq \
		-r $BED \
		-o "results/"$stem".rseqc.build" \
	&& mv"results/"$stem".rseqc.build" "results/"$stem".rseqc"
#This module will calculate how mapped reads were distributed over genome feature and when genome features are overlapped.
	read_distribution.py \
		-i $prereq \
		-r $BED \
		> "results/"$stem".read_distribution.txt.build" \
	&& mv"results/"$stem".read_distribution.txt.build" "results/"$stem".read_distribution.txt"
#Two strategies were used to determine reads duplication rate: * Sequence based: reads with identical sequence are regarded as duplicated reads. * Mapping based: reads mapped to the exactly same genomic location are regarded as duplicated reads.
	read_duplication.py \
		-i $prereq \
		-o "results/"$stem".read_duplication.build" \
	&& mv "results/"$stem".read_duplication.build"  "results/"$stem".read_duplication" 

