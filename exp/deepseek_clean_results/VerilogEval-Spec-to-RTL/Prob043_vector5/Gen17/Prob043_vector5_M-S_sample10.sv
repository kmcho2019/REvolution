module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

    // Self comparisons (always 1)
    wire aa = 1'b1;
    wire bb = 1'b1;
    wire cc = 1'b1;
    wire dd = 1'b1;
    wire ee = 1'b1;
    
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

    assign out = {
        aa, ab, ac, ad, ae,
        ab, bb, bc, bd, be,
        ac, bc, cc, cd, ce,
        ad, bd, cd, dd, de,
        ae, be, ce, de, ee
    };

endmodule