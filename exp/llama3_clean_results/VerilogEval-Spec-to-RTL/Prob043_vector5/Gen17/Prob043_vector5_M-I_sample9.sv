module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    assign out[24] = ~(a ^ a);
    assign out[23] = ~(a ^ b);
    assign out[22] = ~(a ^ c);
    assign out[21] = ~(a ^ d);
    assign out[20] = ~(a ^ e);

    assign out[19] = ~(a ^ b); // Symmetric comparison, same as out[23]
    assign out[18] = ~(b ^ b);
    assign out[17] = ~(b ^ c);
    assign out[16] = ~(b ^ d);
    assign out[15] = ~(b ^ e);

    assign out[14] = ~(a ^ c); // Symmetric comparison, same as out[22]
    assign out[13] = ~(b ^ c); // Symmetric comparison, same as out[17]
    assign out[12] = ~(c ^ c);
    assign out[11] = ~(c ^ d);
    assign out[10] = ~(c ^ e);

    assign out[9]  = ~(a ^ d); // Symmetric comparison, same as out[21]
    assign out[8]  = ~(b ^ d); // Symmetric comparison, same as out[16]
    assign out[7]  = ~(c ^ d); // Symmetric comparison, same as out[11]
    assign out[6]  = ~(d ^ d);
    assign out[5]  = ~(d ^ e);

    assign out[4]  = ~(a ^ e); // Symmetric comparison, same as out[20]
    assign out[3]  = ~(b ^ e); // Symmetric comparison, same as out[15]
    assign out[2]  = ~(c ^ e); // Symmetric comparison, same as out[10]
    assign out[1]  = ~(d ^ e); // Symmetric comparison, same as out[5]
    assign out[0]  = ~(e ^ e);

endmodule