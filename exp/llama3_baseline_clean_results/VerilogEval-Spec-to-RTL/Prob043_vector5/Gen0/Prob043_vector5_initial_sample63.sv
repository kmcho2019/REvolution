module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Compare 'a' with all signals
    assign out[24] = ~(a ^ a);
    assign out[23] = ~(a ^ b);
    assign out[22] = ~(a ^ c);
    assign out[21] = ~(a ^ d);
    assign out[20] = ~(a ^ e);

    // Compare 'b' with remaining signals
    assign out[19] = ~(b ^ b);
    assign out[18] = ~(b ^ c);
    assign out[17] = ~(b ^ d);
    assign out[16] = ~(b ^ e);

    // Compare 'c' with remaining signals
    assign out[15] = ~(c ^ c);
    assign out[14] = ~(c ^ d);
    assign out[13] = ~(c ^ e);

    // Compare 'd' with remaining signals
    assign out[12] = ~(d ^ d);
    assign out[11] = ~(d ^ e);

    // Compare 'e' with itself
    assign out[10] = ~(e ^ e);

    // Assign the remaining comparisons
    assign out[9]  = ~(a ^ a);
    assign out[8]  = ~(b ^ a);
    assign out[7]  = ~(c ^ a);
    assign out[6]  = ~(d ^ a);
    assign out[5]  = ~(e ^ a);
    assign out[4]  = ~(b ^ b);
    assign out[3]  = ~(c ^ b);
    assign out[2]  = ~(d ^ b);
    assign out[1]  = ~(e ^ d);
    assign out[0]  = ~(e ^ e);

endmodule