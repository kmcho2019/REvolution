module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

assign sum = a ^ b;  // XOR operation to generate sum
assign cout = a & b;  // AND operation to generate carry-out

endmodule