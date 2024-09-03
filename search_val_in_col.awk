BEGIN {
    FS = ",";                         # Set the field separator to a comma for CSV files
    column_name = ARGV[1];            # The name of the column to search for, passed as the first argument
    search_value = ARGV[2];           # The value to search for, passed as the second argument
    ARGV[1] = ARGV[2] = "";           # Clear ARGV[1] and ARGV[2] so they aren't treated as filenames
}

NR == 1 {
    header = $0;                      # Save the header row to print later
    for (i = 1; i <= NF; i++) {
        if ($i == column_name) {
            target_col = i;           # Store the index of the column
            found_column = 1;         # Flag that the column has been found
            break;                    # Stop the loop once the column is found
        }
    }
    if (!found_column) {
        print "Column '" column_name "' not found.";
        exit;                        # Exit if the column is not found in the header
    }
}

NR > 1 && found_column {
    if ($target_col == search_value) {
        if (!printed_header) {       # Check if header has been printed
            print header;             # Print the header before the first matching line
            printed_header = 1;       # Mark header as printed
        }
        print $0;                    # Print the matching row
    }
}
