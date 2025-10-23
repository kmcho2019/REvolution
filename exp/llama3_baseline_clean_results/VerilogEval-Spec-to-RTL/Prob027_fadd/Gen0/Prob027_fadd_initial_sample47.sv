module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

assign sum = a ^ b ^ cin;  // The sum is the XOR of all three inputs
assign cout = (a & b) | (a & cin) | (b & cin);  // The carry-out is 1 if at least two of the inputs are 1

endmodule