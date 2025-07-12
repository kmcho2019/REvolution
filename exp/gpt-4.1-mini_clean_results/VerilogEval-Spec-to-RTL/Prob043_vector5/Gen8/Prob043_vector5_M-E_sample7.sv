module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Macro for equality using XNOR operator
    `define EQUAL(x,y) ((x) ~^ (y))

    assign out[24] = `EQUAL(a, a);
    assign out[23] = `EQUAL(a, b);
    assign out[22] = `EQUAL(a, c);
    assign out[21] = `EQUAL(a, d);
    assign out[20] = `EQUAL(a, e);

    assign out[19] = `EQUAL(b, a);
    assign out[18] = `EQUAL(b, b);
    assign out[17] = `EQUAL(b, c);
    assign out[16] = `EQUAL(b, d);
    assign out[15] = `EQUAL(b, e);

    assign out[14] = `EQUAL(c, a);
    assign out[13] = `EQUAL(c, b);
    assign out[12] = `EQUAL(c, c);
    assign out[11] = `EQUAL(c, d);
    assign out[10] = `EQUAL(c, e);

    assign out[9] = `EQUAL(d, a);
    assign out[8] = `EQUAL(d, b);
    assign out[7] = `EQUAL(d, c);
    assign out[6] = `EQUAL(d, d);
    assign out[5] = `EQUAL(d, e);

    assign out[4] = `EQUAL(e, a);
    assign out[3] = `EQUAL(e, b);
    assign out[2] = `EQUAL(e, c);
    assign out[1] = `EQUAL(e, d);
    assign out[0] = `EQUAL(e, e);

endmodule