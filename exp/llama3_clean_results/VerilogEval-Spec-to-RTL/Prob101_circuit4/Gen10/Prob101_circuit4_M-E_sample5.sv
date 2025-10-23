module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire [3:0] lut_addr;
assign lut_addr = {a, b, c, d};

wire [0:0] lut_out;
assign lut_out = (lut_addr == 4'b0000) ? 1'b0 :
                 (lut_addr == 4'b0001) ? 1'b0 :
                 (lut_addr == 4'b0010) ? 1'b1 :
                 (lut_addr == 4'b0011) ? 1'b1 :
                 (lut_addr == 4'b0100) ? 1'b1 :
                 (lut_addr == 4'b0101) ? 1'b1 :
                 (lut_addr == 4'b0110) ? 1'b1 :
                 (lut_addr == 4'b0111) ? 1'b1 :
                 (lut_addr == 4'b1000) ? 1'b0 :
                 (lut_addr == 4'b1001) ? 1'b0 :
                 (lut_addr == 4'b1010) ? 1'b1 :
                 (lut_addr == 4'b1011) ? 1'b1 :
                 (lut_addr == 4'b1100) ? 1'b1 :
                 (lut_addr == 4'b1101) ? 1'b1 :
                 (lut_addr == 4'b1110) ? 1'b1 :
                 (lut_addr == 4'b1111) ? 1'b1 : 1'b0;

assign q = lut_out;

endmodule