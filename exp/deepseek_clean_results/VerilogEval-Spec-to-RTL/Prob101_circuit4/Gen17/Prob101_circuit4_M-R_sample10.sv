/*
 * TopModule - Combinational logic module (always block version)
 * 
 * Functionality identical to original:
 *   Output q is the logical OR of inputs b and c
 *   Inputs a and d are unused but required by interface
 * 
 * Refactored to use always block instead of continuous assignment
 * while maintaining identical behavior and PPA characteristics.
 */
module TopModule (
    input  a,       // Unused input (interface requirement)
    input  b,       // First OR operand
    input  c,       // Second OR operand
    input  d,       // Unused input (interface requirement)
    output reg q    // OR result of b and c (now reg type for always block)
);

    // Implementation Notes:
    // - Combinational always block replaces continuous assignment
    // - Still synthesizes to same single OR gate
    // - Explicit sensitivity to all inputs for completeness
    always @(*) begin
        q = b | c;
    end

endmodule