## shows the VEP annotations in a VCF
BEGIN	{
	FS="	";
	}
/^##INFO=<ID=CSQ,/ {
	i=  index($0,"Format: ");
	header= substr($0,i+8);
	i= index(header,"\"");
	header= substr(header,1,i-1);
	ncols = split(header,columns,"|");
	next;
	}
/^#CHROM/ {
	printf("#CHROM\tPOS\tID");
	for(i=1;i<=ncols;++i) printf("\t%s",columns[i]);
	printf("\n");
	next;
	}
/^#/ {
	next;
	}

	{
	ninfo = split($8,info,";");
	for(i=1;i<= ninfo;++i) {
		if(substr(info[i],1,4) !=  "CSQ=") continue;
		info[i] = substr(info[i],5);
		ncsq =  split(info[i],csq,","); 
		for(j=1; j<= ncsq; ++j) {
			ntokens = split(csq[j],tokens,"|"); 
			printf("%s\t%s\t%s",$1,$2,$3);
			for(k=1;k<=ntokens;++k) printf("\t%s",(tokens[k]==""?".":tokens[k]));
			printf("\n");
			}
		}
	}
