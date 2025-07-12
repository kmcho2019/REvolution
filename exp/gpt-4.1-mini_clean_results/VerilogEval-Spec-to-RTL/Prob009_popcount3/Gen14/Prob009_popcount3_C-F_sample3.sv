module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Explicitly sum individual bits to produce population count (0 to 3)
    // This expression clarifies intent and can help synthesis tools optimize
    // with minimal glitching due to small logic depth.
    assign out = (in[0] ? 1'b1 : 1'b0) +
                 (in[1] ? 1'b1 : 1'b0) +
                 (in[2] ? 1'b1 : 1'b0);

endmodule