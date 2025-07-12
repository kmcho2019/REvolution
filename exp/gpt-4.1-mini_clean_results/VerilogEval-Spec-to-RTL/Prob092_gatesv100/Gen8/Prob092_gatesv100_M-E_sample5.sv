module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Shift input left by 1, pad LSB with 0 - represents neighbor to left except for MSB
    wire [99:0] in_shift_left = {in[98:0], 1'b0};

    // Shift input right by 1, pad MSB with 0 - neighbor to right except for LSB
    wire [99:0] in_shift_right = {1'b0, in[99:1]};

    // out_both[i] = in[i] & neighbor to left (in[i-1]), except out_both[99] = 0 (no neighbor)
    assign out_both = in & in_shift_left;
    assign out_both[99] = 1'b0; // override the bit with no neighbor

    // out_any[i] = in[i] | neighbor to right (in[i+1]), except out_any[0] = 0 (no neighbor)
    assign out_any = in | in_shift_right;
    assign out_any[0] = 1'b0; // override the bit with no neighbor

    // For out_different, neighbor to left with wrap-around: {in[0], in[99:1]}
    wire [99:0] in_wrap_left = {in[0], in[99:1]};
    assign out_different = in ^ in_wrap_left;

endmodule