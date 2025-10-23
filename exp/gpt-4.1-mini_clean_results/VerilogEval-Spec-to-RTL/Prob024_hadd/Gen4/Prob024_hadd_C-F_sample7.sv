module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

// Half adder implementation:
// sum is XOR of inputs a and b
assign sum = a ^ b;

// carry-out is AND of inputs a and b
assign cout = a & b;

endmodule