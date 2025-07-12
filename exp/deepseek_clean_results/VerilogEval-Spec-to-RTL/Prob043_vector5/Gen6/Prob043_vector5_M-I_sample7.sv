module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Self-comparisons (always 1)
    assign out[24] = 1'b1;  // a == a
    assign out[18] = 1'b1;  // b == b
    assign out[12] = 1'b1;  // c == c
    assign out[6]  = 1'b1;  // d == d
    assign out[0]  = 1'b1;  // e == e

    // Unique pairwise comparisons
    wire ab = a ~^ b;
    wire ac = a ~^ c;
    wire ad = a ~^ d;
    wire ae = a ~^ e;
    wire bc = b ~^ c;
    wire bd = b ~^ d;
    wire be = b ~^ e;
    wire cd = c ~^ d;
    wire ce = c ~^ e;
    wire de = d ~^ e;

    // Assign all outputs using the precomputed values
    assign out[23:20] = {ab, ac, ad, ae};
    assign out[19] = ab;  // b == a (same as a == b)
    assign out[17:15] = {bc, bd, be};
    assign out[14] = ac;  // c == a
    assign out[13] = bc;  // c == b
    assign out[11:10] = {cd, ce};
    assign out[9] = ad;   // d == a
    assign out[8] = bd;   // d == b
    assign out[7] = cd;   // d == c
    assign out[5] = de;
    assign out[4] = ae;   // e == a
    assign out[3] = be;   // e == b
    assign out[2] = ce;   // e == c
    assign out[1] = de;   // e == d

endmodule