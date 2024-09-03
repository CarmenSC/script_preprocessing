BEGIN {
    FS = ",";
    # Generate a timestamp for unique output filenames
    timestamp = strftime("%Y-%m-%d_%H-%M-%S");
}

# Initialize arrays with header names for clear output
NR == 1 {
    for (i = 1; i <= NF; i++) {
        header[i] = $i;
    }
    next;
}

# For the second record, initialize comparison values
NR == 2 {
    for (i = 1; i <= NF; i++) {
        values[i] = $i;
        same[i] = 1;
    }
}

# For all other records
NR > 2 {
    for (i = 1; i <= NF; i++) {
        if (same[i] && $i != values[i]) {
            same[i] = 0;
        }
    }
}

# After processing all rows
END {
    for (i = 1; i <= NF; i++) {
        if (same[i]) {
            print "Column " header[i] " has the same value in all rows: " values[i];
            print header[i] > ("same_cols_" timestamp);
        } else {
            print "Column " header[i] " has different values.";
            print header[i] > ("different_vals_cols_" timestamp);
        }
    }
}

