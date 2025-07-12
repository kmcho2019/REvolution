module TopModule (
    input  a,      // Unused input (optimized away)
    input  b,      // OR operand 1
    input  c,      // OR operand 2
    input  d,      // Unused input (optimized away)
    output q       // Output: b OR c
);
    // Functional implementation:
    // q is high when either b or c is high (a and d are don't cares)
    assign q = b | c;
endmodule