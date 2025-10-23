module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);
    // Compute unique comparisons (10 operations instead of 20)
    wire ab = ~(a ^ b);
    wire ac = ~(a ^ c);
    wire ad = ~(a ^ d);
    wire ae = ~(a ^ e);
    wire bc = ~(b ^ c);
    wire bd = ~(b ^ d);
    wire be = ~(b ^ e);
    wire cd = ~(c ^ d);
    wire ce = ~(c ^ e);
    wire de = ~(d ^ e);

    assign out = {
        // Row 1 (a vs all)
        1'b1, ab, ac, ad, ae,
        // Row 2 (b vs all)
        ab, 1'b1, bc, bd, be,
        // Row 3 (c vs all)
        ac, bc, 1'b1, cd, ce,
        // Row 4 (d vs all)
        ad, bd, cd, 1'b1, de,
        // Row 5 (e vs all)
        ae, be, ce, de, 1'b1
    };
endmodule