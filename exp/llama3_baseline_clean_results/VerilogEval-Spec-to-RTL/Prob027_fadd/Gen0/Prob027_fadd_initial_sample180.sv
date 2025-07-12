module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

assign sum = a ^ b ^ cin; // XOR operation for sum
assign cout = (a & b) | (a & cin) | (b & cin); // Carry-out condition

endmodule