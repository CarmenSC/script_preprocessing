awk -F, '                         # Set the field separator as comma for CSV
NR == 1 {                         
    for (i = 1; i <= NF; i++) {
        header[i] = $i;            # Save header names
    }
    next;                         
}
NR == 2 {                         # For the second record, initialize comparison values
    for (i = 1; i <= NF; i++) {
        values[i] = $i;            # Store the second row's values
        same[i] = 1;               # Assume all values are the same initially
    }
}
NR > 2 {                          # For all other records
    for (i = 1; i <= NF; i++) {
        if ($i != values[i]) {    # If the current row value is different,
            same[i] = 0;          # mark as different
        }
    }
}
END {                             # After processing all rows
    for (i = 1; i <= NF; i++) {
        if (same[i])              # If the value is the same for a column,
            print "Column " header[i] " has the same value in all rows: " values[i];
        else
            print "Column " header[i] " has different values.";
    }
}' yourfile.csv



### How to: awk -f check_columns.awk yourfile.csv



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
        if ($i != values[i]) {    # If the current row value is different,
            same[i] = 0;          # mark as different
        }
    }
}

# After processing all rows
END {
    for (i = 1; i <= NF; i++) {
        if (same[i])              # If the value is the same for a column,
            print "Column " header[i] " has the same value in all rows: " values[i];
        else
            print "Column " header[i] " has different values.";
    }
}
