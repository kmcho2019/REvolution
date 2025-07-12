module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

// Calculate sum using XOR of a, b, and cin
assign sum = a ^ b ^ cin;

// Calculate carry-out using (a and b) or (a and cin) or (b and cin)
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule