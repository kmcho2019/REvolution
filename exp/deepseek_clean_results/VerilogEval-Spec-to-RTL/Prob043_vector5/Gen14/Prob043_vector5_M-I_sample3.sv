module TopModule (
    input  a, b, c, d, e,
    output [24:0] out
);
    // Precompute all unique pairwise comparisons
    wire ab = (a == b);
    wire ac = (a == c);
    wire ad = (a == d);
    wire ae = (a == e);
    wire bc = (b == c);
    wire bd = (b == d);
    wire be = (b == e);
    wire cd = (c == d);
    wire ce = (c == e);
    wire de = (d == e);

    // a comparisons
    assign out[24] = 1'b1;    // a == a
    assign out[23] = ab;      // a == b
    assign out[22] = ac;      // a == c
    assign out[21] = ad;      // a == d
    assign out[20] = ae;      // a == e

    // b comparisons
    assign out[19] = ab;      // b == a (reuse)
    assign out[18] = 1'b1;    // b == b
    assign out[17] = bc;      // b == c
    assign out[16] = bd;      // b == d
    assign out[15] = be;      // b == e

    // c comparisons
    assign out[14] = ac;      // c == a (reuse)
    assign out[13] = bc;      // c == b (reuse)
    assign out[12] = 1'b1;   // c == c
    assign out[11] = cd;      // c == d
    assign out[10] = ce;      // c == e

    // d comparisons
    assign out[9]  = ad;      // d == a (reuse)
    assign out[8]  = bd;      // d == b (reuse)
    assign out[7]  = cd;      // d == c (reuse)
    assign out[6]  = 1'b1;    // d == d
    assign out[5]  = de;      // d == e

    // e comparisons
    assign out[4]  = ae;      // e == a (reuse)
    assign out[3]  = be;      // e == b (reuse)
    assign out[2]  = ce;      // e == c (reuse)
    assign out[1]  = de;      // e == d (reuse)
    assign out[0]  = 1'b1;    // e == e
endmodule