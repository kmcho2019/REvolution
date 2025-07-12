module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Shift left by 1, mask off the MSB as no neighbor to left for in[3]
    wire [3:0] in_shift_left = {in[2:0], 1'b0};
    assign out_both = in & in_shift_left;

    // Shift right by 1, mask off the LSB as no neighbor to right for in[0]
    wire [3:0] in_shift_right = {1'b0, in[3:1]};
    assign out_any = in | in_shift_right;

    // Rotate left by 1: in[2:0], in[3] => in[3], in[2:0]
    wire [3:0] in_rot_left = {in[2:0], in[3]};
    assign out_different = in ^ in_rot_left;

endmodule