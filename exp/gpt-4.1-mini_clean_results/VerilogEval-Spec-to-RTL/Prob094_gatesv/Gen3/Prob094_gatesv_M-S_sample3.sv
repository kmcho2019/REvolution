module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

wire [3:0] in_rot_left  = {in[2:0], in[3]};
wire [3:0] in_rot_right = {in[0], in[3:1]};

assign out_both      = (in & in_rot_left) & 4'b0111;  // zero MSB
assign out_any       = (in | in_rot_right) & 4'b1110; // zero LSB
assign out_different = in ^ in_rot_left;              // wrap-around XOR

endmodule