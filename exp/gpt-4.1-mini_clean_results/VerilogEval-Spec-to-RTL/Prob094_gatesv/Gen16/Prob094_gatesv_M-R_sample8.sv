module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // For out_both: each bit except MSB is AND of in[i] and in[i+1]
    // Shift left by 1, mask MSB to 0
    wire [3:0] in_left = {in[2:0], 1'b0};
    assign out_both = in & in_left;

    // For out_any: each bit except LSB is OR of in[i] and in[i-1]
    // Shift right by 1, mask LSB to 0
    wire [3:0] in_right = {1'b0, in[3:1]};
    assign out_any = in | in_right;

    // For out_different: XOR of in with its left neighbor wrapping around
    // Rotate input left by 1 bit, then XOR
    wire [3:0] in_rotated = {in[2:0], in[3]};
    assign out_different = in ^ in_rotated;

endmodule