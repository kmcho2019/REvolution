module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shifted vectors
    wire [3:0] in_left_shift  = {in[2:0], 1'b0};  // Shift left by 1, fill LSB with 0
    wire [3:0] in_right_shift = {1'b0, in[3:1]};  // Shift right by 1, fill MSB with 0
    wire [3:0] in_left_rot    = {in[2:0], in[3]}; // Rotate left by 1 bit for wrap-around

    // out_both: both current bit and left neighbor are 1, mask out MSB (no left neighbor)
    assign out_both = (in & in_left_shift) & 4'b0111;

    // out_any: either current bit or right neighbor are 1, mask out LSB (no right neighbor)
    assign out_any = (in | in_right_shift) & 4'b1110;

    // out_different: current bit different from left neighbor (wrap-around)
    assign out_different = in ^ in_left_rot;

endmodule