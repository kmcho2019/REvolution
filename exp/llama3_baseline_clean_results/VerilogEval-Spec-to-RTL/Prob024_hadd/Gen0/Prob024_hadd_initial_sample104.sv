module TopModule(
    input a,
    input b,
    output sum,
    output cout
);

assign sum = a ^ b;  // XOR operation to calculate sum
assign cout = a & b; // AND operation to calculate carry-out

endmodule