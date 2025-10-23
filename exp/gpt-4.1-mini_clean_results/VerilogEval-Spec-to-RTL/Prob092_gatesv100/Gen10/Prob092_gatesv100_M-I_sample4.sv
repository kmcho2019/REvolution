module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Shifted versions of input for neighbor access
    wire [99:0] in_shift_left  = {in[98:0], 1'b0};   // shift left by 1, MSB neighbor doesn't exist => zero
    wire [99:0] in_shift_right = {1'b0, in[99:1]};   // shift right by 1, LSB neighbor doesn't exist => zero

    // out_both: AND with left neighbor, zero MSB (bit 99)
    wire [99:0] temp_both = in & in_shift_left;
    assign out_both = temp_both & 100'h7FFFFFFFFFFFFFFFFFFFFFFFFF; // mask MSB bit to zero (bit 99)

    // out_any: OR with right neighbor, zero LSB (bit 0)
    wire [99:0] temp_any = in | in_shift_right;
    assign out_any = temp_any & 100'hFFFFFFFFFFFFFFFFFFFFFFFFE; // mask LSB bit to zero (bit 0)

    // out_different: XOR with left neighbor with wrap-around
    wire [99:0] in_rot_left = {in[98:0], in[99]};
    assign out_different = in ^ in_rot_left;

endmodule