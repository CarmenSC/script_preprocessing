BEGIN {
    FS = ",";               # Set field separator for CSV files
    OFS = ",";              # Set output field separator for CSV files
}

# Load the list of column names to delete from the first file
NR == FNR {
    delete_columns[$1] = 1; # Mark this column name for deletion
    next;
}

# The header of the CSV: identify which columns to skip
FNR == 1 {
    first = 1;              # Flag to handle the first column printing
    for (i = 1; i <= NF; i++) {
        if (!($i in delete_columns)) {
            keep_columns[i] = 1;   # Mark this column to keep
            if (!first) {
                printf("%s", OFS); # Print comma before every column except the first
            }
            printf("%s", $i);   # Print the column name
            first = 0;          # Unset the first column flag after the first print
        }
    }
    print "";   # Finish the header line
    next;
}

# Process each subsequent row of the CSV
{
    first = 1;              # Reset the first column flag for each row
    for (i = 1; i <= NF; i++) {
        if (i in keep_columns) {
            gsub(/^=/, "", $i);  # Remove leading equals sign in each field
            if (!first) {
                printf("%s", OFS); # Print comma before every column except the first
            }
            printf("%s", $i);   # Print the column value
            first = 0;          # Unset the first column flag after the first print
        }
    }
    print "";   # Finish the data line
}
