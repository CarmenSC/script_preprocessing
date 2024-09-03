BEGIN {
    FS = ",";                         # Set field separator to comma
    OFS = ",";                        # Output field separator also comma
    # Process extra arguments for column names to convert
    for (i = 3; i < ARGC; i++) {
        convert_columns[ARGV[i]] = 1;
    }
    # Remove arguments so they're not treated as file names
    for (i = 3; i < ARGC; i++) {
        ARGV[i] = "";
    }
}

# Process the header and find indices of columns to convert
NR == 1 {
    for (i = 1; i <= NF; i++) {
        header[i] = $i;                # Store original header names
        if ($i in convert_columns) {
            convert_idx[i] = 1;        # Mark this index for conversion
        }
        printf("%s%s", (i > 1 ? OFS : ""), header[i]); # Print header
    }
    print "";  # Finish the header line
    next;
}

# Process each data row
{
    for (i = 1; i <= NF; i++) {
        # Remove double quotes
        gsub(/"/, "", $i);
        
        if (i in convert_idx) {
            # Convert timestamp to formatted datetime
            seconds = $i / 1000000000;  # Convert nanoseconds to seconds
            nanoseconds = $i % 1000000000;
            datetime = strftime("%Y.%m.%dD%H:%M:%S", seconds);
            printf("%s\"%s.%09d\"", (i > 1 ? OFS : ""), datetime, nanoseconds);
        } else {
            # Print unmodified data, ensuring to maintain original quoting
            printf("%s\"%s\"", (i > 1 ? OFS : ""), $i);
        }
    }
    print "";  # Finish the data line
}

## awk -f convert_timestamps.awk input.csv output.csv "Timestamp1" "Timestamp2"

