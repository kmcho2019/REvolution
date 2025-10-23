module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Circular left rotate of 'in' by 1: left neighbor for out_different
    wire [3:0] in_rot_left = {in[2:0], in[3]};

    // For out_both: in & (in shifted left by 1), but bit 3 no neighbor to left => 0
    wire [3:0] in_shift_left = {in[2:0], 1'b0};
    assign out_both = in & in_shift_left;

    // For out_any: in | (in shifted right by 1), but bit 0 no neighbor to right => 0
    wire [3:0] in_shift_right = {1'b0, in[3:1]};
    assign out_any = in | in_shift_right;

    // For out_different: XOR with circular left-rotated input (wrap-around)
    assign out_different = in ^ in_rot_left;

endmodule