module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

// Compare a with all inputs
assign out[24] = ~(a ^ a);
assign out[23] = ~(a ^ b);
assign out[22] = ~(a ^ c);
assign out[21] = ~(a ^ d);
assign out[20] = ~(a ^ e);

// Compare b with all inputs except a (since a^b is already compared)
assign out[19] = ~(b ^ b);
assign out[18] = ~(b ^ c);
assign out[17] = ~(b ^ d);
assign out[16] = ~(b ^ e);

// Compare c with all inputs except a and b
assign out[15] = ~(c ^ c);
assign out[14] = ~(c ^ d);
assign out[13] = ~(c ^ e);

// Compare d with all inputs except a, b, and c
assign out[12] = ~(d ^ d);
assign out[11] = ~(d ^ e);

// Compare e with all inputs except a, b, c, and d
assign out[10] = ~(e ^ e);

// Assign the remaining bits to avoid latches
assign out[9] = 1'b0;
assign out[8] = 1'b0;
assign out[7] = 1'b0;
assign out[6] = 1'b0;
assign out[5] = 1'b0;
assign out[4] = 1'b0;
assign out[3] = 1'b0;
assign out[2] = 1'b0;
assign out[1] = ~(e ^ d);
assign out[0] = ~(e ^ e);

endmodule