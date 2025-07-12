module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // For out_both: bit and left neighbor
    // Shift in left by 1 bit: in[98:0] moves to out_both[98:0] with in[99] dropped.
    // out_both[99] = 0 as no left neighbor
    wire [99:0] in_shift_left = {in[98:0], 1'b0};
    assign out_both = in & in_shift_left;

    // For out_any: bit or right neighbor
    // Shift in right by 1 bit: in[99:1] moves to out_any[98:0], out_any[0] = 0
    wire [99:0] in_shift_right = {1'b0, in[99:1]};
    assign out_any = in | in_shift_right;

    // For out_different: XOR with left neighbor, wrap-around
    // Rotate input left by one bit (wrap-around)
    wire [99:0] in_rot_left = {in[98:0], in[99]};
    assign out_different = in ^ in_rot_left;

endmodule