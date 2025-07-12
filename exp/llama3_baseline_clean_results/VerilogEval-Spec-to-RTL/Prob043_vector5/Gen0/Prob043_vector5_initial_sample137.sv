module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

assign out[24] = ~(a ^ a); // a vs a
assign out[23] = ~(a ^ b); // a vs b
assign out[22] = ~(a ^ c); // a vs c
assign out[21] = ~(a ^ d); // a vs d
assign out[20] = ~(a ^ e); // a vs e
assign out[19] = ~(b ^ b); // b vs b
assign out[18] = ~(b ^ c); // b vs c
assign out[17] = ~(b ^ d); // b vs d
assign out[16] = ~(b ^ e); // b vs e
assign out[15] = ~(c ^ c); // c vs c
assign out[14] = ~(c ^ d); // c vs d
assign out[13] = ~(c ^ e); // c vs e
assign out[12] = ~(d ^ d); // d vs d
assign out[11] = ~(d ^ e); // d vs e
assign out[10] = ~(e ^ e); // e vs e
assign out[9] = ~(a ^ b);  // already computed
assign out[8] = ~(a ^ c);  // already computed
assign out[7] = ~(a ^ d);  // already computed
assign out[6] = ~(a ^ e);  // already computed
assign out[5] = ~(b ^ a);  // same as ~(a ^ b)
assign out[4] = ~(b ^ c);  // already computed
assign out[3] = ~(b ^ d);  // already computed
assign out[2] = ~(b ^ e);  // already computed
assign out[1] = ~(e ^ d);  // same as ~(d ^ e)
assign out[0] = ~(e ^ e);  // already computed

// alternative solution
// assign out = {~(a^a), ~(a^b), ~(a^c), ~(a^d), ~(a^e),
//               ~(b^b), ~(b^c), ~(b^d), ~(b^e),
//               ~(c^c), ~(c^d), ~(c^e),
//               ~(d^d), ~(d^e),
//               ~(e^e)};

endmodule