/*
 * TopModule - Combinational logic implementing q = b OR c
 * 
 * Truth Table:
 * b c | q
 * ----|---
 * 0 0 | 0
 * 0 1 | 1
 * 1 0 | 1
 * 1 1 | 1
 * 
 * Note: Inputs a and d are unused but maintained for interface compliance
 */
module TopModule (
    input  a,       // Unused (interface requirement)
    input  b,       // First OR operand
    input  c,       // Second OR operand 
    input  d,       // Unused (interface requirement)
    output q        // Output: Logical OR of b and c
);
    // Implementation:
    // Direct OR implementation matching specified truth table behavior
    assign q = b | c;
endmodule