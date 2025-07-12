module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

    // Half adder implementation:
    // sum = a XOR b
    // cout = a AND b
    assign sum = a ^ b;
    assign cout = a & b;

endmodule