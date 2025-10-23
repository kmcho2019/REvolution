module TopModule (
    input  a,      // Unused input (interface requirement)
    input  b,      // OR operand 1 - q is 1 when b is 1
    input  c,      // OR operand 2 - q is 1 when c is 1
    input  d,      // Unused input (interface requirement)
    output q       // Output: Logical OR of b and c (q = b | c)
);

    // Functional implementation:
    // Output q follows the truth table where it's 1 when either b or c is 1
    // Inputs a and d are unused but maintained for interface compatibility
    assign q = b | c;

endmodule