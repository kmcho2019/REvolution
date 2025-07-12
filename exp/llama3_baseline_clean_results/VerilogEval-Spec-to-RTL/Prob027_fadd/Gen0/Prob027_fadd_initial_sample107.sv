module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

assign sum = a ^ b ^ cin;  // The sum bit is the XOR of the three input bits
assign cout = (a & b) | (a & cin) | (b & cin);  // The carry bit is set if any two input bits are 1

endmodule