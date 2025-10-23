module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..98, out_both[99] = 0
    // Construct shifted vector in shifted left by 1 bit, padding MSB with 0
    wire [99:0] in_left_shifted = {in[98:0], 1'b0};
    assign out_both = in & in_left_shifted;

    // out_any[i] = in[i] | in[i-1] for i=1..99, out_any[0] = 0
    // Construct shifted vector in shifted right by 1 bit, padding LSB with 0
    wire [99:0] in_right_shifted = {1'b0, in[99:1]};
    assign out_any = in | in_right_shifted;

    // out_different[i] = in[i] ^ in[(i+1) mod 100] (circular left shift by 1)
    wire [99:0] in_circ_left = {in[98:0], in[99]};
    assign out_different = in ^ in_circ_left;

endmodule