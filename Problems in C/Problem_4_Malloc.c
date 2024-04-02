#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

// Function Prototype
bool isValidCell(int row, int column, int rows, int columns);
int DFS(int **matrix, int row, int column, int rows, int columns);
int findLargestIsland(int **matrix, int rows, int columns);

int main(void) {
    int rows, columns;

    // Read matrix dimensions
    printf("Enter number of rows and columns: ");
    scanf("%d %d", &rows, &columns);

    // Dynamically allocate memory for the matrix
    int **matrix = (int **)malloc(rows * sizeof(int *));
    for (int i = 0; i < rows; ++i) {
        matrix[i] = (int *)malloc(columns * sizeof(int));
    }

    // Read matrix elements
    printf("Enter matrix elements (0s and 1s):\n");
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < columns; ++j) {
            scanf("%d", &matrix[i][j]);
        }
    }

    // Print the matrix
    printf("Matrix:\n");
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < columns; ++j) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }

    // Find the largest island
    int largestIsland = findLargestIsland(matrix, rows, columns);
    printf("The number of the 1s on the largest island is %d.\n", largestIsland);

    // Free dynamically allocated memory
    for (int i = 0; i < rows; ++i) {
        free(matrix[i]);
    }
    free(matrix);

    return 0;
}

// Function to check if a given cell is a valid cell in the matrix
bool isValidCell(int row, int column, int rows, int columns) {
    return (row >= 0 && row < rows && column >= 0 && column < columns);
}

// Function to perform depth-first search (DFS) to find the size of the island
int DFS(int **matrix, int row, int column, int rows, int columns) {
    if (!isValidCell(row, column, rows, columns) || matrix[row][column] == 0)
        return 0;

    // Mark the current cell as visited
    matrix[row][column] = 0;

    // Define the four directions: up, down, left, right
    int directions[4][2] = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};

    // Initialize island size to 1 (current cell)
    int size = 1;

    // Traverse all four directions
    for (int i = 0; i < 4; ++i) {
        int newRow = row + directions[i][0];
        int newCol = column + directions[i][1];
        size += DFS(matrix, newRow, newCol, rows, columns);
    }

    return size;
}

// Function to find the largest island in the matrix
int findLargestIsland(int **matrix, int rows, int columns) {
    int maxIslandSize = 0;

    // Traverse each cell in the matrix
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < columns; ++j) {
            if (matrix[i][j] == 1) {
                int islandSize = DFS(matrix, i, j, rows, columns);
                if (islandSize > maxIslandSize)
                    maxIslandSize = islandSize;
            }
        }
    }

    return maxIslandSize;
}

