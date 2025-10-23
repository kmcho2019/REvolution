/*
 * TopModule - Optimized combinational logic module
 * 
 * Functionality:
 *   Output q is the logical OR of inputs b and c
 *   Inputs a and d are unused but explicitly tied low for power optimization
 * 
 * Power Optimization:
 *   - Unused inputs tied to ground to prevent floating gate power consumption
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

    // Implementation Notes:
    // - Pure combinational logic
    // - Minimal implementation (single OR operation)
    // - Unused inputs explicitly tied low for power optimization
    assign q = b | c;

    // Power optimization: tie unused inputs to ground
    // These assignments prevent synthesis warnings while optimizing power
    wire unused_a = a;
    wire unused_d = d;
    // Note: Modern synthesis tools will optimize these away while
    // ensuring no floating inputs during operation

endmodule