module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Direct ternary operator for clean implementation
    // Synthesis tools will automatically optimize this
    assign out = sel ? b : a;

    // Optional: Add synthesis attributes to guide optimization
    /* synthesis parallel_case */
    /* synthesis full_case */

endmodule