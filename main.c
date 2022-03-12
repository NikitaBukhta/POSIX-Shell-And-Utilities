#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv, char** envp)
{
    FILE *outputFile;
    char fileName[] = "Result-output.txt";
    char* MY_VAR;

    putenv("MY_VAR=Hello world!");
    if ((MY_VAR = getenv("MY_VAR")) == NULL)
    {
        return 123;
    }
    else if (argc > 1)
    {
        if ((outputFile = fopen(fileName, "w")) == NULL)
        {
            return 1;
        }
        
        fprintf(outputFile, "%s\n", MY_VAR);
        fclose(outputFile);
    }
    else
    {
        fputs(MY_VAR, stdout);
        printf("\n");
        fclose(outputFile);
    }

    return 0;
}