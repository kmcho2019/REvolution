/*
 * TopModule - Combinational logic module (Gate-level implementation)
 * 
 * Functionality:
 *   Output q is the logical OR of inputs b and c
 *   Implemented using explicit OR gate primitive
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

    // Implementation Notes:
    // - Explicit gate-level implementation
    // - Uses Verilog OR primitive
    // - Unused inputs left floating as they don't affect functionality
    or g1(q, b, c);

endmodule