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

//////////////
t2: update Symbol: `$first each "." vs' string Symbol from t2

n KDB+/q, you can achieve the desired trimming of the Symbol column by using string manipulation functions. Here’s how you can modify each symbol to keep only the part before the dot:

Convert the symbol to a string: The string function can be used to convert the symbol type to a string type.
Find the dot position and substring: Use the ss function to find the position of the dot in each string and then the sublist function to take the substring up to the dot.
Here is the query to achieve this:

q
Copiar código
t2: update newSymbol: `$sublist[0; ss[string Symbol; "."]] string Symbol from t2
Let's break down what this does:

string Symbol converts the symbol values to strings.
ss[string Symbol; "."] finds the first occurrence of the dot in each string.
sublist[0; ss[string Symbol; "."]] string Symbol takes the substring from the beginning to just before the dot for each symbol.
``$` converts the resulting string back to a symbol type.
update newSymbol: ... from t2 creates a new column newSymbol with the modified values while preserving the original Symbol column.
After running this, t2 will have an additional column newSymbol with the symbols trimmed as needed. If you wish to replace the original Symbol column instead, you could adjust the query slightly:

q
Copiar código
t2: update Symbol: `$sublist[0; ss[string Symbol; "."]] string Symbol from t2
