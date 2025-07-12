module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Perform each unique comparison only once and assign the result to both corresponding output bits
    assign out[24] = 1'b1;  // Always 1, as a ^ a is always 0
    assign out[23] = ~(a ^ b);
    assign out[22] = ~(a ^ c);
    assign out[21] = ~(a ^ d);
    assign out[20] = ~(a ^ e);

    assign out[19] = out[23];  // Symmetry: a ^ b == b ^ a
    assign out[18] = 1'b1;  // Always 1, as b ^ b is always 0
    assign out[17] = ~(b ^ c);
    assign out[16] = ~(b ^ d);
    assign out[15] = ~(b ^ e);

    assign out[14] = out[22];  // Symmetry: a ^ c == c ^ a
    assign out[13] = out[17];  // Symmetry: b ^ c == c ^ b
    assign out[12] = 1'b1;  // Always 1, as c ^ c is always 0
    assign out[11] = ~(c ^ d);
    assign out[10] = ~(c ^ e);

    assign out[9] = out[21];  // Symmetry: a ^ d == d ^ a
    assign out[8] = out[16];  // Symmetry: b ^ d == d ^ b
    assign out[7] = out[11];  // Symmetry: c ^ d == d ^ c
    assign out[6] = 1'b1;  // Always 1, as d ^ d is always 0
    assign out[5] = ~(d ^ e);

    assign out[4] = out[20];  // Symmetry: a ^ e == e ^ a
    assign out[3] = out[15];  // Symmetry: b ^ e == e ^ b
    assign out[2] = out[10];  // Symmetry: c ^ e == e ^ c
    assign out[1] = out[5];  // Symmetry: d ^ e == e ^ d
    assign out[0] = 1'b1;  // Always 1, as e ^ e is always 0

endmodule