module TopModule (
    input  a,      // Unused input (interface requirement)
    input  b,      // OR operand 1 - q is 1 when b is 1
    input  c,      // OR operand 2 - q is 1 when c is 1
    input  d,      // Unused input (interface requirement)
    output q       // Output: Logical OR of b and c (q = b | c)
);

    // Implementation Notes:
    // - Output q is high when either b OR c is high
    // - Inputs a and d are unused but maintained for interface compatibility
    // - This matches all test cases in the waveform
    assign q = b | c;

endmodule