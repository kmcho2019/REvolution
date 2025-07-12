// Given the existing solution is already optimized for the task,
// our main focus is on ensuring the synthesis process is optimized
// for area and performance. However, we can slightly modify the
// existing code for better readability and potentially easier
// optimization by the synthesis tool.

module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Direct assignments are already used, which is efficient.
    // We keep the existing logic as it's already optimized.
    assign out_hi = in[15:8]; // Upper 8 bits
    assign out_lo = in[7:0];  // Lower 8 bits

endmodule