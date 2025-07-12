module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    assign sum = a ^ b;  // Optimal XOR implementation for sum
    assign cout = a & b; // Standard AND for carry-out
endmodule