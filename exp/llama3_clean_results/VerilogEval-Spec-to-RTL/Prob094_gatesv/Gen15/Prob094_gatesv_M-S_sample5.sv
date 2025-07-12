module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Compute out_both
    assign out_both[0] = in[0] & in[1];
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = 1'b0;  // As specified, no neighbor to the left for in[3]

    // Compute out_any
    assign out_any[0] = in[0];  // No neighbor to the right, consider only itself
    assign out_any[1] = in[1] | in[0];
    assign out_any[2] = in[2] | in[1];
    assign out_any[3] = in[3] | in[2];

    // Compute out_different, considering wrap-around for in[3]
    assign out_different[0] = in[0] ^ in[3];  // in[0]'s left neighbor is in[3]
    assign out_different[1] = in[1] ^ in[2];
    assign out_different[2] = in[2] ^ in[3];
    assign out_different[3] = in[3] ^ in[0];  // in[3]'s left neighbor is in[0]

endmodule