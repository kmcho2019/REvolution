module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

assign sum = a ^ b ^ cin; // XOR of a, b, and cin gives the sum
assign cout = (a & b) | (a & cin) | (b & cin); // carry-out is generated when at least two of the inputs are 1

endmodule