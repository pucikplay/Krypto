#include <stdio.h>
#include <memory.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <dirent.h>
#include <ctype.h>
#include "sha256.h"
#include <time.h>

char * hash_to_string(BYTE * buff) {
	char * string = (char *)malloc(70);
	int k, i;
	for (i = 0, k = 0; i < 32; i++, k+= 2)
	{
		sprintf(string + k, "%.2x", buff[i]);
		//printf("%02x", buff[i]);
	}
	string[64] = 0;
	return string;
}

char * trim(char *str){
    size_t len = 0;
    char *frontp = str;
    char *endp = NULL;

    if( str == NULL ) { return NULL; }
    if( str[0] == '\0' ) { return str; }

    len = strlen(str);
    endp = str + len;

    /* Move the front and back pointers to address the first non-whitespace
     * characters from each end.
     */
    while( isspace((unsigned char) *frontp) ) { ++frontp; }
    if( endp != frontp )
    {
        while( isspace((unsigned char) *(--endp)) && endp != frontp ) {}
    }

    if( str + len - 1 != endp )
            *(endp + 1) = '\0';
    else if( frontp != str &&  endp == frontp )
            *str = '\0';

    /* Shift the string so that it starts at str so that if it's dynamically
     * allocated, we can still free it on the returned pointer.  Note the reuse
     * of endp to mean the front of the string buffer now.
     */
    endp = str;
    if( frontp != str )
    {
            while( *frontp ) { *endp++ = *frontp++; }
            *endp = '\0';
    }


    return str;
}

BYTE * get_file_data(char * fname, unsigned long * size) {
	FILE * f = 0;
	BYTE * buffer = 0;
	unsigned long fsize = 0;

	f = fopen(fname, "rb");
	if (!f){
		fprintf(stderr, "get_file_data Unable to open '%s'\n", fname);
		return 0;
	}
	fflush(f);

	if (fseek(f, 0, SEEK_END)){
		fprintf(stderr, "Unable to fseek %s\n", fname);
		return 0;
	}
	fflush(f);
	fsize = ftell(f);
	rewind(f);

	buffer = (char *)malloc((fsize+1)*sizeof(char));
	fread(buffer, fsize, 1, f);
	fclose(f);
	*size = fsize;
	return buffer;
}

int main(int argc, char **argv) {
	int i = 0, n = 0;
	size_t len;
	unsigned long temp;
	char * a_file = 0, * line = 0;
	BYTE * buff;
	char option, index;
	ssize_t read;
	BYTE buf[SHA256_BLOCK_SIZE];
	SHA256_CTX ctx;
	struct timespec begin, end; 

	// parse input
	while ((option = getopt(argc, argv,"hf:")) != -1)
		switch (option) {
			case 'h' :
				// print_usage();
				break;
			case 'f' :
				a_file = optarg;
				break;
			default:
				break;
		}


	if (a_file) {
		FILE * f = 0;
		f = fopen(a_file, "r");
		if (!f){
			fprintf(stderr, "Unable to open %s\n", a_file);
			return 0;
		}

		for (n = 0; getline(&line, &len, f) != -1; n++){}
		fseek(f, 0, SEEK_SET);

		n = 0;
		clock_gettime(CLOCK_REALTIME, &begin);
		read = getline(&line, &len, f);
		while (read != -1) {
			read = getline(&line, &len, f);
			line = trim(line);
			buff = get_file_data(line, &temp);
			// printf("%s\n", line);
			// printf("%c\n", buff[0]);

			sha256_init(&ctx);
			sha256_update(&ctx, buff, temp);
			sha256_final(&ctx, buf);
			// printf("%s\n", hash_to_string(buf));
		}
		clock_gettime(CLOCK_REALTIME, &end);

		long seconds = end.tv_sec - begin.tv_sec;
		long nanoseconds = end.tv_nsec - begin.tv_nsec;
		double elapsed = seconds + nanoseconds*1e-9;
		printf("%f\n", elapsed);
	}
	return 0;
}