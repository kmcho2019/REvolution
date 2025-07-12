module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

wire [99:0] in_left  = {in[98:0], 1'b0};   // in shifted left by 1 with zero at LSB
wire [99:0] in_right = {1'b0, in[99:1]};  // in shifted right by 1 with zero at MSB
wire [99:0] in_rot   = {in[0], in[99:1]}; // in rotated right by 1

assign out_both      = in & in_left;
assign out_any       = in | in_right;
assign out_different = in ^ in_rot;

endmodule