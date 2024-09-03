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
    for (i = 1; i <= NF; i++) {
        if (!($i in delete_columns)) {
            keep_columns[i] = 1;   # Mark this column to keep
            printf("%s%s", (i == 1 ? "" : OFS), $i);
        }
    }
    print "";   # Finish the header line
    next;
}

# Process each subsequent row of the CSV
{
    for (i = 1; i <= NF; i++) {
        if (i in keep_columns) {
            printf("%s%s", (i == 1 ? "" : OFS), $i); # Print only columns marked to keep
        }
    }
    print "";   # Finish the data line
}

#awk -f delete_columns.awk columns_to_delete.txt input.csv > output.csv
