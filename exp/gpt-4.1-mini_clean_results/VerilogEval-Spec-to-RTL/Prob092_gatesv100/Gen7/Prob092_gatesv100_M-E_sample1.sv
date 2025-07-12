module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Shift in left by 1; bit 0 discarded, bit 99 zero-filled.
    wire [99:0] in_shift_left = {in[98:0], 1'b0};
    // out_both[i] = in[i] & in[i+1], so using shifted version AND original.
    assign out_both = (in & in_shift_left) & ~(1'b1 << 99); // clear out_both[99]

    // Shift in right by 1; bit 99 discarded, bit 0 zero-filled.
    wire [99:0] in_shift_right = {1'b0, in[99:1]};
    // out_any[i] = in[i] | in[i-1], so OR with shifted right version.
    assign out_any = (in | in_shift_right) & ~1'b1; // clear out_any[0]

    // For out_different, use circular left rotate by 1 bit (neighbor to left with wrap-around)
    wire [99:0] in_rotate_left = {in[98:0], in[99]};
    assign out_different = in ^ in_rotate_left;

endmodule