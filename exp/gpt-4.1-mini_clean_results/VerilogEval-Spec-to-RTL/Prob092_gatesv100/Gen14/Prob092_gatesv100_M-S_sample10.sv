module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

assign out_both = (in & (in << 1)) & ~100'b1;          // MSB zeroed
assign out_any  = (in | (in >> 1)) & {99'b1,1'b0};     // LSB zeroed
assign out_different = in ^ {in[0], in[99:1]};          // left rotate by 1 for wrap-around

endmodule