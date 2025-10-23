module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99] = 0
    // Shift in left by 1 bit with zero padding, AND with in, mask off MSB bit
    wire [99:0] in_shift_left = {in[98:0], 1'b0};
    assign out_both = (in & in_shift_left) & {99{1'b1}, 1'b0};

    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0] = 0
    // Shift in right by 1 bit with zero padding, OR with in, mask off LSB bit
    wire [99:0] in_shift_right = {1'b0, in[99:1]};
    assign out_any = (in | in_shift_right) & {1'b0, {99{1'b1}}};

    // out_different[i] = in[i] ^ in[(i+1) mod 100]
    assign out_different = in ^ {in[0], in[99:1]};

endmodule