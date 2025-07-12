module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1]; MSB (bit 99) has no left neighbor, so 0
    // Shift in left by 1 bit, pad LSB with 0 (logical shift left)
    wire [99:0] in_left_shift = {in[98:0], 1'b0};
    assign out_both = in & in_left_shift;

    // out_any[i] = in[i] | in[i-1]; LSB (bit 0) has no right neighbor, so 0
    // Shift in right by 1 bit, pad MSB with 0 (logical shift right)
    wire [99:0] in_right_shift = {1'b0, in[99:1]};
    assign out_any = in | in_right_shift;

    // out_different[i] = in[i] ^ in[(i+1) mod 100]; wrap-around neighbor on left
    // Perform rotate left by 1 bit (wrap-around left neighbor)
    wire [99:0] in_rotate_left = {in[98:0], in[99]};
    assign out_different = in ^ in_rotate_left;

endmodule