module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Precompute inverted inputs
    wire na, nb, nc, nd, ne;
    assign na = ~a;
    assign nb = ~b;
    assign nc = ~c;
    assign nd = ~d;
    assign ne = ~e;

    // Compare a with all inputs (including itself)
    assign out[24] = ~(na ^ a);
    assign out[23] = ~(na ^ b);
    assign out[22] = ~(na ^ c);
    assign out[21] = ~(na ^ d);
    assign out[20] = ~(na ^ e);

    // Compare b with all inputs (including itself)
    assign out[19] = ~(nb ^ a);
    assign out[18] = ~(nb ^ b);
    assign out[17] = ~(nb ^ c);
    assign out[16] = ~(nb ^ d);
    assign out[15] = ~(nb ^ e);

    // Compare c with all inputs (including itself)
    assign out[14] = ~(nc ^ a);
    assign out[13] = ~(nc ^ b);
    assign out[12] = ~(nc ^ c);
    assign out[11] = ~(nc ^ d);
    assign out[10] = ~(nc ^ e);

    // Compare d with all inputs (including itself)
    assign out[9]  = ~(nd ^ a);
    assign out[8]  = ~(nd ^ b);
    assign out[7]  = ~(nd ^ c);
    assign out[6]  = ~(nd ^ d);
    assign out[5]  = ~(nd ^ e);

    // Compare e with all inputs (including itself)
    assign out[4]  = ~(ne ^ a);
    assign out[3]  = ~(ne ^ b);
    assign out[2]  = ~(ne ^ c);
    assign out[1]  = ~(ne ^ d);
    assign out[0]  = ~(ne ^ e);

endmodule