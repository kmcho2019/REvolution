/*
 * TopModule - Combinational logic module
 * 
 * Functionality:
 *   Output q is the logical OR of inputs b and c
 *   Inputs a and d are unused but required by interface
 * 
 * Truth Table:
 *   q = b | c (regardless of a and d values)
 */
module TopModule (
    input  a,       // Unused input (interface requirement)
    input  b,       // First OR operand
    input  c,       // Second OR operand
    input  d,       // Unused input (interface requirement)
    output q        // OR result of b and c
);

    // Direct continuous assignment of OR operation
    assign q = b | c;

endmodule