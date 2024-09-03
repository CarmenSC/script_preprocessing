BEGIN {
    FS = ",";                         # Set the field separator to a comma for CSV files
    column_name = ARGV[1];            # The name of the column to search for, passed as the first argument
    search_value = ARGV[2];           # The value to search for, passed as the second argument
    ARGV[1] = ARGV[2] = "";           # Clear ARGV[1] and ARGV[2] so they aren't treated as filenames
}

NR == 1 {
    for (i = 1; i <= NF; i++) {
        if ($i == column_name) {
            target_col = i;           # Store the index of the column
            break;                    # Stop the loop once the column is found
        }
    }
    if (target_col == "") {
        print "Column '" column_name "' not found.";
        exit;                        # Exit if the column is not found in the header
    }
}

NR > 1 {
    if ($target_col == search_value) {  # Check if the target column contains the specific value
        print $0;                       # Print the whole line if it matches
    }
}
#how to: awk -f script_name.awk "Column Name" "Value to Search" yourfile.csv
#example: awk -f search_by_header.awk "Status" "\"=2370\"" yourfile.csv
