module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Efficient 100-bit 2:1 mux with optimal timing
    // Note: For system-level optimization, consider:
    // - Clock gating if used in sequential logic
    // - Operand isolation if inputs are stable during certain cycles
    assign out = sel ? b : a;

endmodule