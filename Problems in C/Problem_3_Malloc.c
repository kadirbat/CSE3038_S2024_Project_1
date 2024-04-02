#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function Prototypes
int isPowerOfTwo(int n);
void swapSubstrings(char *substring, int length, int n);

int main(void) {
    // Declare pointer to char and initialize it to NULL
    char *InputString = NULL; 
    int ShuffleTimes = 0;
    int length = 0;
    char c;

    // Dynamically allocate memory for the input string
    InputString = malloc(sizeof(char));

    printf("Input: ");
    // Read input character by character until a blank line is encountered
    while ((c = getchar()) != '\n' || length == 0) {
        if (c == EOF || c == '\0') {
            printf("Error: Unexpected end of input.\n");
            // Free dynamically allocated memory
            free(InputString);
            exit(1);
        }

        InputString[length] = c;
        length++;
        char *temp = malloc((length + 1) * sizeof(char));
        if (temp == NULL) {
            printf("Memory allocation failed.\n");
            free(InputString); // Free dynamically allocated memory
            exit(1);
        }
        for (int i = 0; i < length; i++) {
            temp[i] = InputString[i];
        }
        temp[length] = '\0'; // Null-terminate the temporary string
        free(InputString);
        InputString = temp;
    }

    printf("Enter the number of shuffle operations: ");
    scanf("%d", &ShuffleTimes);

    if (!isPowerOfTwo(length)) {
        printf("Error: The length of the input string must be a power of two.\n");
        free(InputString); // Free dynamically allocated memory
        return 1;
    }

    // Perform shuffle operation
    swapSubstrings(InputString, length, ShuffleTimes);

    // Print shuffled string
    printf("Output: \"%s\"\n", InputString);

    // Free dynamically allocated memory
    free(InputString);

    return 0;
}

int isPowerOfTwo(int n) {
    return (n & (n - 1)) == 0;
}

// Function to recursively swap substrings in a string
void swapSubstrings(char *substring, int length, int n) {
    if (n <= 0)
        return;

    int mid = length / 2;

    // Allocate memory for temporary substring
    char *temp = malloc((mid + 1) * sizeof(char));

    if (temp == NULL) {
        printf("Memory allocation failed.\n");
        exit(1);
    }

    // Copy first half of the substring to temp
    for (int i = 0; i < mid; i++) {
        temp[i] = substring[i];
    }
    temp[mid] = '\0'; // Null-terminate the temporary string

    // Swap first half with second half
    for (int i = 0; i < mid; i++) {
        char tempChar = substring[i];
        substring[i] = substring[mid + i];
        substring[mid + i] = tempChar;
    }

    // Recursively swap sub-substrings
    swapSubstrings(substring, mid, n - 1);
    swapSubstrings(substring + mid, mid, n - 1);

    // Free dynamically allocated memory
    free(temp);
}
