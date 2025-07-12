/*
 * TopModule - Optimized OR gate implementation
 * 
 * Function: q = b OR c
 * Optimization: Inputs a and d unused (automatically optimized)
 */
module TopModule (
    input  a,  // Unused input (optimized away)
    input  b,  // OR operand 1
    input  c,  // OR operand 2
    input  d,  // Unused input (optimized away)
    output q   // OR result
);

    assign q = b | c;

endmodule