module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Half adder implementation
    assign sum = a ^ b,  // XOR for sum
           cout = a & b; // AND for carry-out

endmodule