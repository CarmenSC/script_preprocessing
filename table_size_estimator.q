// Define a function to estimate size, considering all common data types
estimateSizeAllTypes:{[t]
    // Initialize total size
    totalSize: 0;
    
    // Numeric, boolean, timestamp types, etc. sizes
    typeSizes: "JjIiHhEeFfGgCcSsBbMmDdZzNnUuVvTtPp"!8 8 4 4 2 2 8 8 4 4 1 1 0 0 1 1 8 8 8 8 8 8 8 8 8 8 8 8 8 8;

    // Loop through each column
    cols: cols t;
    eachColSizes: {colType: type first x;
                   // Handle regular types
                   if[colType in key typeSizes;
                      :count[x] * typeSizes colType];
                   
                   // Handle symbols specifically
                   if[colType = -11;
                      :8 * count distinct x];
                   
                   // Handle general lists (This is simplistic; nested lists are more complex)
                   if[colType = 0;
                      :sum each estimateSizeAllTypes each x];
                   
                   // Handle strings
                   if[colType = 10;
                      :sum count each x];
                  } each flip t;
    
    // Calculate total size
    totalSize: sum eachColSizes;

    // Return total size
    totalSize
}

// Example Table with Mixed Types
tMixed: ([] intCol: 1 2 3; symCol: `symbol1`symbol2`symbol3; strCol: ("abc";"def";"ghi"); nestedCol: (1 2 3; `a`b; 10.5 20.5))

// Calculate Estimated Size
estimateSizeAllTypes tMixed
