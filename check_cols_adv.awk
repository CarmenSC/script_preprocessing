# Set the field separator as comma for CSV
BEGIN { FS="," }

# Initialize arrays with header names for clear output
NR == 1 {
    for (i = 1; i <= NF; i++) {
        header[i] = $i;            # Save header names
    }
    next;                         # Skip to next record (avoid comparing headers)
}

# For the second record, initialize comparison values
NR == 2 {
    for (i = 1; i <= NF; i++) {
        values[i] = $i;            # Store the second row's values
        same[i] = 1;               # Assume all values are the same initially
    }
}

# For all other records
NR > 2 {
    for (i = 1; i <= NF; i++) {
        if (same[i] && $i != values[i]) {    # Check if column is still marked as same and current value is different
            same[i] = 0;          # mark as different
        }
    }
}

# After processing all rows
END {
    for (i = 1; i <= NF; i++) {
        if (same[i]) {            # If the value is the same for a column,
            print "Column " header[i] " has the same value in all rows: " values[i];
            print header[i] > "scols_w_same_vals";   # Write to file for columns with the same values
        } else {
            print "Column " header[i] " has different values.";
            print header[i] > "different_vals_cols"; # Write to file for columns with different values
        }
    }
}
