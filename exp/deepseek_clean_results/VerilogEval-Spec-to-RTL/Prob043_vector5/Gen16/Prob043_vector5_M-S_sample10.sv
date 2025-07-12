module TopModule (
    input  a, b, c, d, e,
    output [24:0] out
);
    // Compute all unique pairwise comparisons
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

    // Assign outputs using concatenation
    assign out = {
        1'b1, ab,   ac,   ad,   ae,    // a comparisons
        ab,   1'b1, bc,   bd,   be,    // b comparisons
        ac,   bc,   1'b1, cd,   ce,    // c comparisons
        ad,   bd,   cd,   1'b1, de,    // d comparisons
        ae,   be,   ce,   de,   1'b1   // e comparisons
    };
endmodule