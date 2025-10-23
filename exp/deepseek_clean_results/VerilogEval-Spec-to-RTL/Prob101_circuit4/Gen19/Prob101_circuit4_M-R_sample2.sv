/*
 * TopModule - Minimal OR gate implementation
 * 
 * Function: q = b OR c
 * Inputs a and d are unused (optimized away during synthesis)
 */
module TopModule (
    input  a,  // Unused input
    input  b,  // First OR operand
    input  c,  // Second OR operand
    input  d,  // Unused input
    output q   // OR result
);

    assign q = b | c;

endmodule