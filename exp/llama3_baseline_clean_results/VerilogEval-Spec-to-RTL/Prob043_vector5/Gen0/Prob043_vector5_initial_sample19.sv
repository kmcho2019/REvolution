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
assign out[9]  = ~(a ^ a); // This is redundant as out[24] = out[9]
assign out[8]  = ~(b ^ a); // Note: This is the same as ~(a ^ b)
assign out[7]  = ~(c ^ a); // Note: This is the same as ~(a ^ c)
assign out[6]  = ~(d ^ a); // Note: This is the same as ~(a ^ d)
assign out[5]  = ~(e ^ a); // Note: This is the same as ~(a ^ e)
assign out[4]  = ~(b ^ b); // This is redundant as out[19] = out[4]
assign out[3]  = ~(c ^ b); // Note: This is the same as ~(b ^ c)
assign out[2]  = ~(d ^ b); // Note: This is the same as ~(b ^ d)
assign out[1]  = ~(e ^ d); // Note: This is the same as ~(d ^ e)
assign out[0]  = ~(e ^ e); // This is redundant as out[10] = out[0]

endmodule