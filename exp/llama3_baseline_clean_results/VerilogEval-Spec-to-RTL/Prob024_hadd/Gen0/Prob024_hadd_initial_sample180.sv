module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

assign sum = a ^ b;  // XOR operation to calculate the sum
assign cout = a & b;  // AND operation to calculate the carry-out

endmodule