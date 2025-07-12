module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

assign out[24] = ~(a ^ a);  // a and a
assign out[23] = ~(a ^ b);  // a and b
assign out[22] = ~(a ^ c);  // a and c
assign out[21] = ~(a ^ d);  // a and d
assign out[20] = ~(a ^ e);  // a and e
assign out[19] = ~(b ^ a);  // b and a
assign out[18] = ~(b ^ b);  // b and b
assign out[17] = ~(b ^ c);  // b and c
assign out[16] = ~(b ^ d);  // b and d
assign out[15] = ~(b ^ e);  // b and e
assign out[14] = ~(c ^ a);  // c and a
assign out[13] = ~(c ^ b);  // c and b
assign out[12] = ~(c ^ c);  // c and c
assign out[11] = ~(c ^ d);  // c and d
assign out[10] = ~(c ^ e);  // c and e
assign out[9]  = ~(d ^ a);  // d and a
assign out[8]  = ~(d ^ b);  // d and b
assign out[7]  = ~(d ^ c);  // d and c
assign out[6]  = ~(d ^ d);  // d and d
assign out[5]  = ~(d ^ e);  // d and e
assign out[4]  = ~(e ^ a);  // e and a
assign out[3]  = ~(e ^ b);  // e and b
assign out[2]  = ~(e ^ c);  // e and c
assign out[1]  = ~(e ^ d);  // e and d
assign out[0]  = ~(e ^ e);  // e and e

endmodule