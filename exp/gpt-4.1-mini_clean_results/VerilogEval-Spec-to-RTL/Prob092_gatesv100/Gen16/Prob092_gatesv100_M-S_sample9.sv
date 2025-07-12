module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1], with out_both[99] = 0
    // Shift in left by 1, padding LSB with 0
    wire [99:0] in_shift_left = {in[98:0], 1'b0};
    assign out_both = in & in_shift_left;

    // out_any[i] = in[i] | in[i-1], with out_any[0] = 0
    // Shift in right by 1, padding MSB with 0
    wire [99:0] in_shift_right = {1'b0, in[99:1]};
    assign out_any = in | in_shift_right;

    // out_different[i] = in[i] ^ in[(i+1) mod 100]
    // Circular left shift of in by 1
    wire [99:0] in_rot_left = {in[98:0], in[99]};
    assign out_different = in ^ in_rot_left;

endmodule