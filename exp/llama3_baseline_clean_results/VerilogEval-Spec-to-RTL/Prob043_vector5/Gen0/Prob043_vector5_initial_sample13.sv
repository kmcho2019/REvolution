module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

// Compute pairwise one-bit comparisons
assign out[24] = ~(a ^ a);  // a with a
assign out[23] = ~(a ^ b);  // a with b
assign out[22] = ~(a ^ c);  // a with c
assign out[21] = ~(a ^ d);  // a with d
assign out[20] = ~(a ^ e);  // a with e
assign out[19] = ~(b ^ a);  // b with a
assign out[18] = ~(b ^ b);  // b with b
assign out[17] = ~(b ^ c);  // b with c
assign out[16] = ~(b ^ d);  // b with d
assign out[15] = ~(b ^ e);  // b with e
assign out[14] = ~(c ^ a);  // c with a
assign out[13] = ~(c ^ b);  // c with b
assign out[12] = ~(c ^ c);  // c with c
assign out[11] = ~(c ^ d);  // c with d
assign out[10] = ~(c ^ e);  // c with e
assign out[9]  = ~(d ^ a);  // d with a
assign out[8]  = ~(d ^ b);  // d with b
assign out[7]  = ~(d ^ c);  // d with c
assign out[6]  = ~(d ^ d);  // d with d
assign out[5]  = ~(d ^ e);  // d with e
assign out[4]  = ~(e ^ a);  // e with a
assign out[3]  = ~(e ^ b);  // e with b
assign out[2]  = ~(e ^ c);  // e with c
assign out[1]  = ~(e ^ d);  // e with d
assign out[0]  = ~(e ^ e);  // e with e

endmodule