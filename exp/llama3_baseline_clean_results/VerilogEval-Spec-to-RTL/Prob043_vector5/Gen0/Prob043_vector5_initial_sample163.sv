module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [24:0] out_reg;

always @(a, b, c, d, e) begin
    out_reg = 25'b0;
    // Assign output bits for comparison of each input signal with itself
    out_reg[24] = ~(a ^ a);  // a with a
    out_reg[9]  = ~(b ^ b);  // b with b
    out_reg[14] = ~(c ^ c);  // c with c
    out_reg[19] = ~(d ^ d);  // d with d
    out_reg[4]  = ~(e ^ e);  // e with e

    // Assign output bits for comparison of each pair of different input signals
    out_reg[23] = ~(a ^ b);  // a with b
    out_reg[22] = ~(a ^ c);  // a with c
    out_reg[21] = ~(a ^ d);  // a with d
    out_reg[20] = ~(a ^ e);  // a with e
    out_reg[18] = ~(b ^ c);  // b with c
    out_reg[17] = ~(b ^ d);  // b with d
    out_reg[16] = ~(b ^ e);  // b with e
    out_reg[15] = ~(c ^ d);  // c with d
    out_reg[13] = ~(c ^ e);  // c with e
    out_reg[12] = ~(d ^ e);  // d with e
    out_reg[11] = ~(b ^ a);  // b with a
    out_reg[10] = ~(c ^ a);  // c with a
    out_reg[8]  = ~(d ^ a);  // d with a
    out_reg[7]  = ~(e ^ a);  // e with a
    out_reg[6]  = ~(c ^ b);  // c with b
    out_reg[5]  = ~(d ^ b);  // d with b
    out_reg[3]  = ~(e ^ b);  // e with b
    out_reg[2]  = ~(d ^ c);  // d with c
    out_reg[1]  = ~(e ^ d);  // e with d
    out_reg[0]  = ~(e ^ c);  // e with c
    out = out_reg;
end

endmodule