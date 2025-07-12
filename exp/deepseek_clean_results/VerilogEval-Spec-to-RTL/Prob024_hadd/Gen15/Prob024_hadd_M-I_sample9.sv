module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);

    // Optimal half-adder implementation using minimal logic gates
    // Note: This module can be used as a building block for full adders
    assign sum  = a ^ b;  // Explicit XOR for sum
    assign cout = a & b;  // Explicit AND for carry-out

endmodule