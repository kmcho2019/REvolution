module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

// Alternatively, recognizing that (a & b) | (a & cin) | (b & cin) essentially checks for any two inputs being high,
// which is equivalent to the condition for a carry in binary addition, the above can be considered as a direct implementation.
// However, for educational purposes, let's illustrate an alternative approach focusing on minimizing operations:

// A more simplified version focusing on the essence of binary addition:
// The carry can be determined by adding the three bits and checking if the result is 2 or 3 (in decimal), 
// which would be 10 or 11 in binary, indicating a carry.

endmodule