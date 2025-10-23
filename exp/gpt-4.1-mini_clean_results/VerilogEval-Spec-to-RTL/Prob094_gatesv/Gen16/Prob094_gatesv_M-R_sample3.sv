module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Shift input left by 1 bit with zero in LSB: {in[2:0], 1'b0}
    wire [3:0] in_shift_left  = {in[2:0], 1'b0};
    // Shift input right by 1 bit with zero in MSB: {1'b0, in[3:1]}
    wire [3:0] in_shift_right = {1'b0, in[3:1]};
    // Rotate input left by 1 bit: {in[2:0], in[3]}
    wire [3:0] in_rotate_left = {in[2:0], in[3]};

    // out_both[i] = in[i] & in[i+1], for i=0..2; out_both[3] = 0
    // Achieved by AND of input and shifted left input, zero MSB
    assign out_both = in & in_shift_left & 4'b0111;

    // out_any[i] = in[i] | in[i-1], for i=1..3; out_any[0] = 0
    // Achieved by OR of input and shifted right input, zero LSB
    assign out_any = (in | in_shift_right) & 4'b1110;

    // out_different[i] = in[i] ^ in[(i+1) mod 4], implemented as XOR with rotated left input
    assign out_different = in ^ in_rotate_left;

endmodule