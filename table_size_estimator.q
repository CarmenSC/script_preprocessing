// Function to estimate the size of various data types in a kdb+/q table
estimateSizeAllTypes: {[t]
    typeSizes: enlist[`boolean`guid`byte`short`int`long`real`float`char`symbol`timestamp`month`date`datetime`timespan`minute`second`time]!enlist[1 16 1 2 4 8 4 8 1 8 8 8 8 8 8 4 4 4];
    totalSize: 0;

    // Iterate over each column
    cols: cols t;
    eachColSizes: {[col]
        colType: type first col;

        // Basic types calculation
        if[colType in keys typeSizes;
            :count[col] * typeSizes colType];

        // Handle symbol columns
        if[colType = -11;
            :8 * count distinct col];

        // Handle character strings (list of chars)
        if[colType = 10h;
            :sum count each col];

        // Recursively handle nested lists
        if[colType = 0;
            :sum estimateSizeAllTypes each col];

        // Default case for types not handled specifically
        :0;
    } each t;

    // Calculate total size by summing up all column sizes
    totalSize +: sum eachColSizes;

    // Return the estimated size
    totalSize;
};

// Test the function with a mixed-type table including lists and strings
tMixed: ([] intCol: 1 2 3; symCol: `symbol1`symbol2`symbol3; strCol: ("abc";"def";"ghi"); nestedList: (1 2 3; `a`b; 10.5 20.5));
estimateSizeAllTypes tMixed
