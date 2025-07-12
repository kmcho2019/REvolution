module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

// Directly calculate sum and carry-out using XOR and AND operators
assign sum = a ^ b;
assign cout = a & b;

endmodule