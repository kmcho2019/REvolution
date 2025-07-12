module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

// Perform pairwise comparisons
assign out[24] = ~(a ^ a);  // a == a
assign out[23] = ~(a ^ b);  // a == b
assign out[22] = ~(a ^ c);  // a == c
assign out[21] = ~(a ^ d);  // a == d
assign out[20] = ~(a ^ e);  // a == e
assign out[19] = ~(b ^ b);  // b == b
assign out[18] = ~(b ^ c);  // b == c
assign out[17] = ~(b ^ d);  // b == d
assign out[16] = ~(b ^ e);  // b == e
assign out[15] = ~(c ^ c);  // c == c
assign out[14] = ~(c ^ d);  // c == d
assign out[13] = ~(c ^ e);  // c == e
assign out[12] = ~(d ^ d);  // d == d
assign out[11] = ~(d ^ e);  // d == e
assign out[10] = ~(e ^ e);  // e == e
assign out[9]  = ~(a ^ b);  // Same as out[23], but for symmetry in ordering
assign out[8]  = ~(a ^ c);  // Same as out[22]
assign out[7]  = ~(a ^ d);  // Same as out[21]
assign out[6]  = ~(a ^ e);  // Same as out[20]
assign out[5]  = ~(b ^ a);  // Same as out[23]
assign out[4]  = ~(b ^ c);  // Same as out[18]
assign out[3]  = ~(b ^ d);  // Same as out[17]
assign out[2]  = ~(b ^ e);  // Same as out[16]
assign out[1]  = ~(e ^ d);  // Same as out[11]
assign out[0]  = ~(e ^ e);  // Same as out[10]

endmodule