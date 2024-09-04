// Function to estimate the size of various data types in a kdb+/q table, including handling of lists
estimateSizeAllTypes: {[t]
    typeSizes: enlist[`boolean`guid`byte`short`int`long`real`float`char`symbol`timestamp`month`date`datetime`timespan`minute`second`time]!enlist[1 16 1 2 4 8 4 8 1 8 8 8 8 8 8 4 4 4];
    totalSize: sum typeSizes[type each flip t] * count each flip t;

    // Calculate for symbol columns (distinct symbols)
    totalSize +: sum 8 * count each distinct each t where type each t = `symbol;

    // Calculate size for lists (more complex structures require recursion)
    totalSize +: sum {[x]
        if[type x = 0;
            :sum estimateSizeAllTypes each x;
        ];
        if[10h = type x;
            :sum count each x;
        ];
        :0
    } each flip t;

    totalSize
};

// Test the function with a mixed-type table including lists and strings
tMixed: ([] intCol: 1 2 3; symCol: `symbol1`symbol2`symbol3; strCol: ("abc";"def";"ghi"); nestedList: (1 2 3; `a`b; 10.5 20.5));
estimateSizeAllTypes tMixed
