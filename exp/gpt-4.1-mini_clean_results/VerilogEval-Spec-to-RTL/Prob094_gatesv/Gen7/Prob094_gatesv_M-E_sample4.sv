module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1], for i=0..2; out_both[3] = 0
    assign out_both = { (in[3] & 1'b0), in[2:0] } & in;

    // more explicit to show bits:
    // left_shift_in = in << 1 with LSB zero padded
    wire [3:0] left_shift_in = {in[2:0], 1'b0};
    assign out_both = in & left_shift_in;

    // out_any[i] = in[i] | in[i-1], for i=1..3; out_any[0] = 0
    wire [3:0] right_shift_in = {1'b0, in[3:1]};
    assign out_any = in | right_shift_in;

    // For out_different, rotate input left by 1 (wrap around),
    // then XOR with original input
    wire [3:0] rotated_left = {in[2:0], in[3]};
    assign out_different = in ^ rotated_left;

endmodule