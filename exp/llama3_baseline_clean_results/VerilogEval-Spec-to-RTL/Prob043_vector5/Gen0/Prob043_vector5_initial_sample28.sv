module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

// Compare a with all inputs
assign out[24] = ~(a ^ a); // a == a
assign out[23] = ~(a ^ b); // a == b
assign out[22] = ~(a ^ c); // a == c
assign out[21] = ~(a ^ d); // a == d
assign out[20] = ~(a ^ e); // a == e

// Compare b with remaining inputs
assign out[19] = ~(b ^ b); // b == b
assign out[18] = ~(b ^ c); // b == c
assign out[17] = ~(b ^ d); // b == d
assign out[16] = ~(b ^ e); // b == e

// Compare c with remaining inputs
assign out[15] = ~(c ^ c); // c == c
assign out[14] = ~(c ^ d); // c == d
assign out[13] = ~(c ^ e); // c == e

// Compare d with remaining inputs
assign out[12] = ~(d ^ d); // d == d
assign out[11] = ~(d ^ e); // d == e

// Compare e with remaining inputs
assign out[10] = ~(e ^ e); // e == e

// Fill in the remaining comparisons in the output vector
assign out[9]  = ~(a ^ b);
assign out[8]  = ~(a ^ c);
assign out[7]  = ~(a ^ d);
assign out[6]  = ~(a ^ e);
assign out[5]  = ~(b ^ a);
assign out[4]  = ~(b ^ c);
assign out[3]  = ~(b ^ d);
assign out[2]  = ~(b ^ e);
assign out[1]  = ~(e ^ d);
assign out[0]  = ~(e ^ e);

endmodule