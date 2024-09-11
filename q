// Convert t1's TransactTime from nanoseconds to milliseconds
t1:`price`Symbol`TransactTime xkey update TransactTime:`timestamp$floor TransactTime%0D00:00:00.001 from t1

// Perform the join
result: t1 lj `price`Symbol`TransactTime xkey t2

// Convert t2's TransactTime from milliseconds to nanoseconds
t2:update TransactTime:`timestamp$TransactTime from t2

// Perform the as-of join
result:t1 aj `price`Symbol`TransactTime xkey t2


// Remove the suffix in t2's Symbol column
t2:update Symbol:`symbol$raze{first[string x]}`.`split each Symbol from t2

// Perform as-of join
result:t1 aj `price`Symbol`TransactTime xkey t2


// Add the .OQ suffix in t1's Symbol column
t1:update Symbol:`symbol$(string Symbol),".OQ" from t1

// Perform as-of join
result:t1 aj `price`Symbol`TransactTime xkey t2

——

// Trim the part after the dot in t2's Symbol column
t2:update Symbol:`symbol$raze {first string x} each `.` vs Symbol from t2

// Perform as-of join
result:t1 aj `price`Symbol`TransactTime xkey t2