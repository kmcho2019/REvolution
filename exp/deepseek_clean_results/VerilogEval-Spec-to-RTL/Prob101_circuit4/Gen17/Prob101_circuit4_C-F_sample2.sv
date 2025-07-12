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

    // Implementation Notes:
    // - Pure combinational logic
    // - Structural implementation using OR gate primitive
    // - Unused inputs left floating as they don't affect functionality
    
    // Intermediate wire declaration
    wire or_out;
    
    // OR gate instantiation
    or U1 (or_out, b, c);
    
    // Output assignment
    assign q = or_out;

endmodule