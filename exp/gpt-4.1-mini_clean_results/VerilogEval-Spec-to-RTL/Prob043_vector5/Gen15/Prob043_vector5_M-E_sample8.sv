module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Mapping of output bits:
    // out[24] = (a,a)
    // out[23] = (a,b)
    // out[22] = (a,c)
    // out[21] = (a,d)
    // out[20] = (a,e)
    // out[19] = (b,a)
    // out[18] = (b,b)
    // out[17] = (b,c)
    // out[16] = (b,d)
    // out[15] = (b,e)
    // out[14] = (c,a)
    // out[13] = (c,b)
    // out[12] = (c,c)
    // out[11] = (c,d)
    // out[10] = (c,e)
    // out[9]  = (d,a)
    // out[8]  = (d,b)
    // out[7]  = (d,c)
    // out[6]  = (d,d)
    // out[5]  = (d,e)
    // out[4]  = (e,a)
    // out[3]  = (e,b)
    // out[2]  = (e,c)
    // out[1]  = (e,d)
    // out[0]  = (e,e)

    // Compute all pairs with XNOR
    assign out[24] = ~(a ^ a);
    assign out[23] = ~(a ^ b);
    assign out[22] = ~(a ^ c);
    assign out[21] = ~(a ^ d);
    assign out[20] = ~(a ^ e);

    assign out[19] = ~(b ^ a);
    assign out[18] = ~(b ^ b);
    assign out[17] = ~(b ^ c);
    assign out[16] = ~(b ^ d);
    assign out[15] = ~(b ^ e);

    assign out[14] = ~(c ^ a);
    assign out[13] = ~(c ^ b);
    assign out[12] = ~(c ^ c);
    assign out[11] = ~(c ^ d);
    assign out[10] = ~(c ^ e);

    assign out[9]  = ~(d ^ a);
    assign out[8]  = ~(d ^ b);
    assign out[7]  = ~(d ^ c);
    assign out[6]  = ~(d ^ d);
    assign out[5]  = ~(d ^ e);

    assign out[4]  = ~(e ^ a);
    assign out[3]  = ~(e ^ b);
    assign out[2]  = ~(e ^ c);
    assign out[1]  = ~(e ^ d);
    assign out[0]  = ~(e ^ e);

endmodule