#! /usr/bin/awk -f 

# helper fn Source: https://gist.github.com/andrewrcollins/1592991
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s) { return rtrim(ltrim(s)); }

# find read refrence alignment

BEGIN {
region = "CM000668.2" # "^>CM000668.2"  #  record #2 of samtools view chr6alignpolchr6_sort.bam | less -S  source: /hpcfs/groups/phoenix-hpc-rc003/joe/correction/chr6HG002
region = "CM000663.2" # test chr1
region = "chr6"
position = 70
seqlenreq = 120
to_pos = position + seqlenreq
aregion = 0   # found region?
aSeq = ""
aPos = 0
stage = 1
}

{

switch (stage) {
	case "1" : # find region
		if ( index( $1, region )) 
			{ stage = "2"    
			  print " Found region " region, stage
			}
		break
	case "2" : # find start
		print aPos, position
		if ((aPos + length($0)) >= position) {
			aSeq = substr($0,(position - aPos), (length($0) - (position - aPos)))
			stage = 3
			print " found start " position, "aPos: " aPos, "aSeq: ", aSeq, " len ", length(aSeq)
		}
                aPos = aPos + length($0)
		break
	case "3" : # find end
		print "3", aPos
                if ((aPos + length($0)) >= (to_pos)) {
			print " last aSeq b4 final append " aSeq, length(aSeq), " to_pos " to_pos, "aPos", aPos
                       aSeq = aSeq substr($0,1,(to_pos - aPos))
                       stage =	4
                } else {
			aSeq = aSeq $0    # append current seq data to aSeq.
			aPos = aPos + length($0)
		}
                break
	case "4" : print aSeq
		   print " length " length(aSeq), aPos
		 exit 1
		break
	default : print "what"
}








# awk '{if ( $1 ~ /^>/ ) { print $0 } }' lnkref
#if ( aregion == 1) {  # found region?
# 	aSeq = aSeq + $0   # build the sequence until len > position + seqlenreq
#	aPos = aPos + len($0)
#	if (aPos >= position) {
#		aSeq = 
#	}
#} else {
#	if ( index( $1, region )) {     #   OR: if ( $1 ~ region )  # where region is "^>CM000668.2" ie 'regex' start of line and match characters. but index seems simpler...
#		aRegion = 1
#	}
#}

}
