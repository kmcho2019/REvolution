module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift in left by 1 bit with zero padding on LSB for out_both calculation
    wire [3:0] in_left_shifted = {in[2:0], 1'b0};
    // Shift in right by 1 bit with zero padding on MSB for out_any calculation
    wire [3:0] in_right_shifted = {1'b0, in[3:1]};
    // Rotate in left by 1 bit (wrap-around) for out_different calculation
    wire [3:0] in_rotated_left = {in[2:0], in[3]};

    // out_both[i] = in[i] & in[i+1]; so use in & shifted left; but out_both[3]=0
    assign out_both = {in[3] & 1'b0, in[2] & in[3], in[1] & in[2], in[0] & in[1]};
    // Or equivalently, use shifted input: out_both = in & (in << 1), zero the last bit
    // Since shifted left fills LSB with 0, no wrap-around.
    // out_both[3] = 0
    // Using vector operations:
    // assign out_both = in & in_left_shifted;
    // out_both[3] = 0; (to override)
    // But since in_left_shifted[3] = in[2], so out_both[3] = in[3] & in[2], which is invalid,
    // So better to manually assign:
    // Therefore the manual bit assign is safer.

    // out_any[i] = in[i] | in[i-1]; out_any[0] = 0
    assign out_any = {in[3] | in[2], in[2] | in[1], in[1] | in[0], 1'b0};

    // out_different[i] = in[i] ^ in[(i+1) mod 4]
    assign out_different = in ^ in_rotated_left;

endmodule