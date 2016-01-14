## answer to  https://www.biostars.org/p/172743/
##  How to find the amino acid residue that is encoded by codon which is encoded by two different adjacent exons 
##  Using UCSC knownGene
## 
##  Usage:
##      curl -s "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/database/knownGene.txt.gz" | gunzip -c | awk -f biostar172743.awk
##

BEGIN	{
	FS="	";
	printf("#NAME\tCHROM\tPOS-0\tSTRAND\tEXON\tCODON-0\tCDNA-0\tPROT-0\n");
	}
	{
	name = $1;
	chrom = $2;
	strand = $3;
	txStart=int($4);
	txEnd=int($5);
	if( txStart == txEnd ) next;
	cdsStart=int($6);
	cdsEnd=int($7);
	if( cdsStart == cdsEnd ) next;
	exonCount=int($8);
	if( exonCount < 2 )  next;
	split($9,exonStarts,"[,]");
	split($10,exonEnds,"[,]");
	len=0;
	cdna_len=0;
	if( strand == "+")
		{
		for(i=1;i+1<=exonCount;i++)
			{
			exonStart = int(exonStarts[i]);
			exonEnd = int(exonEnds[i]);
			for(pos=exonStart;pos<exonEnd;pos++)
				{
				if(pos < cdsStart ) continue;
				if(pos >= cdsEnd ) continue;
				cdna_len++;
				codon= cdna_len%3;
				if((codon!=0 && pos+1>=exonEnd))
					{
					printf("%s\t%s\t%d\t%s\tExon_%d\t%d\t%d\t%d\n",name,chrom,pos,strand,i,codon,cdna_len,int(cdna_len/3));
					}
				}
			}
		}
	else ## strand is '-'
		{
		for(i=exonCount;i>=2;i--)
			{
			exonStart = int(exonStarts[i]);
			exonEnd = int(exonEnds[i]);
			for(pos=exonEnd-1;pos>=exonStart;pos--)
				{
				if(pos < cdsStart ) continue;
				if(pos >= cdsEnd ) continue;
				cdna_len++;
				codon= cdna_len%3;
				if(codon!=0 && pos-1<exonStart)
					{
					printf("%s\t%s\t%d\t%s\tExon_%d\t%d\t%d\t%d\n",name,chrom,pos,strand,i,codon,cdna_len,int(cdna_len/3));
					}
				}
			}
		}
	}
