#! /usr/bin/awk -f 

BEGIN {

}

{

cig=$6; 
seq=$10;
print "Cigar: ", $6
print "Seq: ", $10
print " ------------------------------"
regex =  "[[:upper:]]+"; 
n=split(cig, arr, regex);
regex =  "[[:digit:]]+";
m=split(cig, brr, regex);
pos=1
read_seq= ""
softClip = ""
hardClip = ""
startsoftclip = 1
posStr = ""
rlen = 1

for ( i=1; i<n; i++ ) {
	# print arr[i] ":" brr[i+1]
	len = arr[i]

	switch( brr[i+1] ) {
	
	case "M" : read_seq = read_seq substr(seq,pos,len)
			pos = pos + len
			addPos = 1
			break;
        case "=" : read_seq = read_seq substr(seq,pos,len)
                        pos = pos + len
                        addPos = 1
                        break;
        case "X" : read_seq = read_seq substr(seq,pos,len)
                        pos = pos + len
                        addPos = 1
                        break;
	case "D" : for(c=0;c<len;c++) read_seq = read_seq "-"
                        pos = pos + len
                        addPos = 1
			break;
        case "I" : for(c=0;c<len;c++) read_seq = read_seq ":"
                        pos = pos + len
                        break;
        case "N" : for(c=0;c<len;c++) read_seq = read_seq "N"
                        pos = pos + len
                        break;
        case "P" : for(c=0;c<len;c++) read_seq = read_seq "P"
                        pos = pos + len
                        break;
        case "S" : softClip = softClip "S" len " "
			if ( pos == 1 ) {
				startsoftclip = len
				rlen = len
			}
                        pos = pos + len
                        break;
        case "H" : hardClip = hardClip "H" len " "
                        # pos does not alter for hard clip 
                        break;

	default:
		break;

	}

printf("len %s\n",len)
if ( addPos = 1 ) {
 for ( j=rlen; j<(rlen+len); j++ ) {
	if ( j % 10 == 0 ) {
        	posStr = posStr j/10
	} else {
                posStr = posStr "."
        }
 }
 rlen = rlen + len
}

#	if ( addPos = 1 ) {
#	 for ( i=1; i<len; i++) {
#        	if ( i % 10 == 0 ) {
#                	posStr = posStr i/10
#}
#	        }  else {
   #     	        posStr = posStr "."
    #    	}
#	 addPos = 0
#	 }
#	} 
printf("%s \n",read_seq);
printf("%s \n",posStr);

}  # for each cigar

printf("%s \n",read_seq);
printf("%s \n",posStr);

posStr = ""
printf("softclipstart %s \n", startsoftclip)
for ( i=startsoftclip; i<pos; i++) {
	if ( i % 10 == 0 ) {
		posStr = posStr i/10 
	}else {
		posStr = posStr "."
	}
}

printf("%s \n",read_seq);
printf("%s \n",posStr);
printf(" = and X, just print seq, P prins P, N prints N, D -, I : \n") 
printf("Soft clipping: %s  Hard clipping: %s \n",softClip,HardClip)
}
