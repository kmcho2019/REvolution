/*
 * TopModule - Combinational logic module
 * 
 * Functionality:
 *   Output q is the logical OR of inputs b and c
 *   Inputs a and d are tied low as they are unused
 * 
 * Truth Table:
 *   q = b | c (regardless of a and d values)
 */
module TopModule (
    input  a,       // Unused input (tied low)
    input  b,       // First OR operand
    input  c,       // Second OR operand
    input  d,       // Unused input (tied low)
    output q        // OR result of b and c
);

    // Implementation Notes:
    // - Pure combinational logic
    // - Minimal implementation (single OR operation)
    // - Unused inputs tied low to prevent switching activity
    /* synthesis syn_keep=1 */
    wire unused_a = 1'b0;
    wire unused_d = 1'b0;
    
    assign q = b | c;

endmodule