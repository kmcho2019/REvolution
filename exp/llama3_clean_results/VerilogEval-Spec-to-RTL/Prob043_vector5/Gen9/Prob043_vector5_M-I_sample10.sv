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

    assign out[19] = out[23]; // Symmetry: a-b is the same as b-a
    assign out[18] = ~(b ^ b);
    assign out[17] = ~(b ^ c);
    assign out[16] = ~(b ^ d);
    assign out[15] = ~(b ^ e);

    assign out[14] = out[22]; // Symmetry
    assign out[13] = out[17]; // Symmetry
    assign out[12] = ~(c ^ c);
    assign out[11] = ~(c ^ d);
    assign out[10] = ~(c ^ e);

    assign out[9] = out[21]; // Symmetry
    assign out[8] = out[16]; // Symmetry
    assign out[7] = out[11]; // Symmetry
    assign out[6] = ~(d ^ d);
    assign out[5] = ~(d ^ e);

    assign out[4] = out[20]; // Symmetry
    assign out[3] = out[15]; // Symmetry
    assign out[2] = out[10]; // Symmetry
    assign out[1] = out[5]; // Symmetry
    assign out[0] = ~(e ^ e);

endmodule