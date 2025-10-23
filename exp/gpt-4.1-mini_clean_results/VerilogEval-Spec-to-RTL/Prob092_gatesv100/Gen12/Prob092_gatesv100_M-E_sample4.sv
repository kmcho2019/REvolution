module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Create left-shifted version of 'in', MSB zero to handle no left neighbor for bit 99
    wire [99:0] in_shift_left = {in[98:0], 1'b0};
    // out_both[i] = in[i] & in[i+1], which is equivalent to in[i] & (in shifted left by one)
    assign out_both = in & in_shift_left;

    // Create right-shifted version of 'in', LSB zero to handle no right neighbor for bit 0
    wire [99:0] in_shift_right = {1'b0, in[99:1]};
    // out_any[i] = in[i] | in[i-1], which is equivalent to in[i] | (in shifted right by one)
    assign out_any = in | in_shift_right;

    // For out_different, perform XOR with left neighbor, wrapping around at boundaries
    // Create rotated vector where left neighbor of in[0] is in[99]
    wire [99:0] in_left_neighbor = {in[0], in[99:1]};
    assign out_different = in ^ in_left_neighbor;

endmodule