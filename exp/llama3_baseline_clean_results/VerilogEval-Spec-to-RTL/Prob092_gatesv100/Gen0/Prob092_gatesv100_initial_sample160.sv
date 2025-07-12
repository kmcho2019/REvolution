module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Compute out_both
    assign out_both[99] = 1'b0; // No neighbor to the left for in[99]
    assign out_both[98:0] = in[98:0] & {1'b0, in[99:1]};

    // Compute out_any
    assign out_any[0] = 1'b0; // No neighbor to the right for in[0]
    assign out_any[99:1] = in[99:1] | {in[98:0], 1'b0};

    // Compute out_different
    assign out_different = in ^ {in[0], in[99:1]};

endmodule