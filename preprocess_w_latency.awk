BEGIN {
    FS = ",";               # Set field separator for CSV files
    OFS = ",";              # Set output field separator for CSV files
}

# Load the list of column names to delete from the first file
NR == FNR {
    delete_columns[$1] = 1; # Mark this column name for deletion
    next;
}

# The header of the CSV: identify which columns to skip and convert, and add new header for Latency
FNR == 1 {
    first = 1;              # Flag to handle the first column printing
    for (i = 1; i <= NF; i++) {
        gsub(/"/, "", $i);  # Remove double quotes for matching
        if (!($i in delete_columns)) {
            keep_columns[i] = 1;   # Mark this column to keep
            convert_idx[i] = ($i == "Timestamp1 (nanoseconds)" || $i == "Timestamp2 (nanoseconds)");
            column_idx[$i] = i;    # Store index of each timestamp column for latency calculation
            if (!first) {
                printf("%s", OFS); # Print comma before every column except the first
            }
            printf("\"%s\"", $i);   # Print the column name with quotes
            first = 0;          # Unset the first column flag after the first print
        }
    }
    printf("%s\"Latency (nanoseconds)\"", OFS);  # Add latency header
    print "";   # Finish the header line
    next;
}

# Process each subsequent row of the CSV
{
    first = 1;              # Reset the first column flag for each row
    timestamp1 = timestamp2 = 0;  # Reset timestamps
    for (i = 1; i <= NF; i++) {
        if (i in keep_columns) {
            gsub(/^="/, "", $i);  # Remove leading equals sign and quote
            gsub(/"$/, "", $i);   # Remove trailing quote
            if (i in convert_idx) {
                # Save original nanosecond timestamps for latency calculation
                if (i == column_idx["Timestamp1 (nanoseconds)"]) timestamp1 = $i;
                if (i == column_idx["Timestamp2 (nanoseconds)"]) timestamp2 = $i;

                # Convert nanosecond timestamp to formatted datetime
                seconds = $i / 1000000000;
                nanoseconds = $i % 1000000000;
                datetime = strftime("%Y.%m.%dD%H:%M:%S", seconds);
                $i = "\"" datetime "." sprintf("%09d", nanoseconds) "\"";
            } else {
                $i = "\"" $i "\""; # Re-add quotes for non-converted fields
            }
            if (!first) {
                printf("%s", OFS); # Print comma before every column except the first
            }
            printf("%s", $i);   # Print the column value
            first = 0;          # Unset the first column flag after the first print
        }
    }
    # Calculate latency and print it
    latency = timestamp1 - timestamp2;
    printf("%s\"%d\"", OFS, latency);  # Print latency
    print "";   # Finish the data line
}
### awk -f script_name.awk columns_to_delete.txt input.csv > output.csv
