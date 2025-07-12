module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

wire [99:0] in_left_shifted = {in[98:0], 1'b0};   // in shifted left by 1 bit, LSB zero
wire [99:0] in_right_shifted = {1'b0, in[99:1]}; // in shifted right by 1 bit, MSB zero
wire [99:0] in_left_rot = {in[0], in[99:1]};     // rotated left by 1 bit

assign out_both = in & in_left_shifted;            // AND with left neighbor; last bit zero
assign out_any = in | in_right_shifted;            // OR with right neighbor; first bit zero
assign out_different = in ^ in_left_rot;           // XOR with left neighbor with wrap-around

endmodule