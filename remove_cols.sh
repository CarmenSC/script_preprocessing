#!/bin/bash

# Check if the correct number of arguments was given
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 columns_to_delete.txt input.csv output.csv"
    exit 1
fi

# Assign arguments to variables for better readability
columns_to_delete_file="$1"
input_csv="$2"
output_csv="$3"

# Generate a list of column indices to keep
indices_to_keep=$(awk -F, -v cols="$columns_to_delete_file" '
BEGIN {
    # Read the columns to delete from the file into an array
    while (getline < cols) {
        delete_cols[$1];
    }
}
NR == 1 {
    # Output column indices to keep
    for (i = 1; i <= NF; i++) {
        if (!($i in delete_cols)) {
            printf "%d,", i;
        }
    }
    print "";  # end the line
}' "$input_csv" | sed 's/,$//')  # Remove the trailing comma

# Use cut to remove the unwanted columns
cut -d, -f"$indices_to_keep" "$input_csv" > "$output_csv"

echo "Processed file saved as $output_csv"

## dont forget to:
### chmod +x remove_columns.sh

## How to run:
#./remove_columns.sh columns_to_delete.txt input.csv output.csv
