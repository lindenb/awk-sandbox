/^$/	{
	if(NR%4==2) {printf("N\n");}
	else if(NR%4==0) {printf("#\n");}
	next;
	}
	{
	print;
	}
