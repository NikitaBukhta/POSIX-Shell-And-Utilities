// Write a program in C, which prints the value of MY_VAR environment variable . 
// If `-o file` option is specified, the value is printed to a file, otherwise to STDOUT. 
// If MY_VAR is not set, an error message is written to STDERR, and the program ends up 
// with a code `123`. If internal errors occur (e.g., no write rights to a directory), 
// the program terminates with a code `1`.

#include <stdio.h>
#include <stdlib.h>

const char FILE_NAME[] = "Result-output.txt";

int main(int argc, char** argv, char** envp)
{
    FILE *outputFile;
    char* MY_VAR;

    putenv("MY_VAR=Hello world!");
    if ((MY_VAR = getenv("MY_VAR")) == NULL)
    {
        return 123;
    }
    else if (argc > 1)
    {
        if ((outputFile = fopen(FILE_NAME, "w")) == NULL) return 1;
        
        fprintf(outputFile, "%s\n", MY_VAR);
        fclose(outputFile);
    }
    else
    {
        fputs(MY_VAR, stdout);
        printf("\n");
    }

    return 0;
}