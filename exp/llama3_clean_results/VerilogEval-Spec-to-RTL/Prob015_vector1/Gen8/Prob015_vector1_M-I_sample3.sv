// The existing code is already optimized for simplicity and directness.
// Given the low power and area metrics, and the absence of timing issues,
// the strategy is to maintain the current implementation.

module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Direct assignment for simplicity and efficiency
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];

endmodule