module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

assign out[24] = ~(a ^ a); // a with a
assign out[23] = ~(a ^ b); // a with b
assign out[22] = ~(a ^ c); // a with c
assign out[21] = ~(a ^ d); // a with d
assign out[20] = ~(a ^ e); // a with e
assign out[19] = ~(b ^ b); // b with b
assign out[18] = ~(b ^ c); // b with c
assign out[17] = ~(b ^ d); // b with d
assign out[16] = ~(b ^ e); // b with e
assign out[15] = ~(c ^ c); // c with c
assign out[14] = ~(c ^ d); // c with d
assign out[13] = ~(c ^ e); // c with e
assign out[12] = ~(d ^ d); // d with d
assign out[11] = ~(d ^ e); // d with e
assign out[10] = ~(e ^ e); // e with e
assign out[9]  = ~(b ^ a); // b with a
assign out[8]  = ~(c ^ a); // c with a
assign out[7]  = ~(d ^ a); // d with a
assign out[6]  = ~(e ^ a); // e with a
assign out[5]  = ~(c ^ b); // c with b
assign out[4]  = ~(d ^ b); // d with b
assign out[3]  = ~(e ^ b); // e with b
assign out[2]  = ~(d ^ c); // d with c
assign out[1]  = ~(e ^ d); // e with d
assign out[0]  = ~(e ^ e); // e with e

endmodule