module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

assign sum = a ^ b ^ cin;  // XOR operation to calculate sum
assign cout = (a & b) | (a & cin) | (b & cin);  // generate carry-out

endmodule