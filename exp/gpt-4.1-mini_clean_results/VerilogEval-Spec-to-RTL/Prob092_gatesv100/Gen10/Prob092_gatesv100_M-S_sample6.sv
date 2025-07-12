module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

assign out_both = (in & (in >> 1)) & ~(1'b1 << 99);           // zero MSB
assign out_any  = (in | (in << 1)) & ~(1'b1);                 // zero LSB
assign out_different = in ^ {in[0], in[99:1]};                // rotate left by 1 for wrap-around

endmodule