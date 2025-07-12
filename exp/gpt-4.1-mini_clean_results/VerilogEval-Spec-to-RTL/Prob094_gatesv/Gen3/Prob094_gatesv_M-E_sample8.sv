module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift left by 1 with zero at LSB for out_both
    wire [3:0] in_left_shift = {in[2:0], 1'b0};
    assign out_both = (in & in_left_shift) & 4'b0111; // Clear bit 3

    // Shift right by 1 with zero at MSB for out_any
    wire [3:0] in_right_shift = {1'b0, in[3:1]};
    assign out_any = (in | in_right_shift) & 4'b1110; // Clear bit 0

    // Rotate left by 1 for wrap-around neighbor comparison
    wire [3:0] in_rot_left = {in[2:0], in[3]};
    assign out_different = in ^ in_rot_left;

endmodule