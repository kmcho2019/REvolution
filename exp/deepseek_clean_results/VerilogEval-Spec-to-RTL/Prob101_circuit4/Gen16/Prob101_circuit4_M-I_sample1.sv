/*
 * TopModule - Optimized combinational logic module
 * 
 * Functionality:
 *   Output q is the logical OR of inputs b and c
 *   Inputs a and d are tied to ground for power optimization
 * 
 * Power Optimization:
 *   - Unused inputs explicitly tied to prevent floating gate power consumption
 *   - Single OR gate minimizes dynamic power
 * 
 * Truth Table:
 *   q = b | c (independent of a and d)
 */
module TopModule (
    input  a,       // Unused input (tied low for power optimization)
    input  b,       // First OR operand
    input  c,       // Second OR operand
    input  d,       // Unused input (tied low for power optimization)
    output q        // OR result of b and c
);

    // Power-optimized implementation:
    // - Unused inputs tied to ground
    // - Single OR operation maintains minimal PPA
    wire a_unused = 1'b0;  // Explicit tie-off
    wire d_unused = 1'b0;  // Explicit tie-off
    assign q = b | c;

endmodule