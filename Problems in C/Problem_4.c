#include <stdio.h>
#include <stdbool.h>

#define MAX_ROWS 100
#define MAX_COLS 100

bool isValidCell(int row, int column, int rows, int cols);
int DFS(int matrix[MAX_ROWS][MAX_COLS], int row, int column, int rows, int cols);
int findLargestIsland(int matrix[MAX_ROWS][MAX_COLS], int rows, int cols);

int main(void) {
    int matrix[MAX_ROWS][MAX_COLS];
    int rows, cols;

    // Read matrix dimensions
    scanf("%d %d", &rows, &cols);

    // Read matrix elements
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            scanf("%d", &matrix[i][j]);
        }
    }

    // Print the matrix
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }

    // Find the largest island
    int largestIsland = findLargestIsland(matrix, rows, cols);
    printf("The number of the 1s on the largest island is %d.\n", largestIsland);

    return 0;
}

// Function to check if a given cell is a valid cell in the matrix
bool isValidCell(int row, int column, int rows, int cols) {
    return (row >= 0 && row < rows && column >= 0 && column < cols);
}

// Function to perform depth-first search (DFS) to find the size of the island
int DFS(int matrix[MAX_ROWS][MAX_COLS], int row, int column, int rows, int cols) {
    if (!isValidCell(row, column, rows, cols) || matrix[row][column] == 0)
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
        int newColumn = column + directions[i][1];
        size += DFS(matrix, newRow, newColumn, rows, cols);
    }

    return size;
}

// Function to find the largest island in the matrix
int findLargestIsland(int matrix[MAX_ROWS][MAX_COLS], int rows, int cols) {
    int maxIslandSize = 0;

    // Traverse each cell in the matrix
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            if (matrix[i][j] == 1) {
                int islandSize = DFS(matrix, i, j, rows, cols);
                if (islandSize > maxIslandSize)
                    maxIslandSize = islandSize;
            }
        }
    }

    return maxIslandSize;
}


