module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [24:0] out_reg;

always @(*) begin
    out_reg[24] = ~(a ^ a);
    out_reg[23] = ~(a ^ b);
    out_reg[22] = ~(a ^ c);
    out_reg[21] = ~(a ^ d);
    out_reg[20] = ~(a ^ e);
    out_reg[19] = ~(b ^ a);
    out_reg[18] = ~(b ^ b);
    out_reg[17] = ~(b ^ c);
    out_reg[16] = ~(b ^ d);
    out_reg[15] = ~(b ^ e);
    out_reg[14] = ~(c ^ a);
    out_reg[13] = ~(c ^ b);
    out_reg[12] = ~(c ^ c);
    out_reg[11] = ~(c ^ d);
    out_reg[10] = ~(c ^ e);
    out_reg[9]  = ~(d ^ a);
    out_reg[8]  = ~(d ^ b);
    out_reg[7]  = ~(d ^ c);
    out_reg[6]  = ~(d ^ d);
    out_reg[5]  = ~(d ^ e);
    out_reg[4]  = ~(e ^ a);
    out_reg[3]  = ~(e ^ b);
    out_reg[2]  = ~(e ^ c);
    out_reg[1]  = ~(e ^ d);
    out_reg[0]  = ~(e ^ e);
    out = out_reg;
end

endmodule