module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Directly assign the upper and lower bytes to out_hi and out_lo
    // This is equivalent to using multiplexers with fixed control signals
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];

endmodule