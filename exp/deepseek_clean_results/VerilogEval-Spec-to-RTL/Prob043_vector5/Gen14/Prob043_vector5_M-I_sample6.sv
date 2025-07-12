module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);
    // Compute unique pairwise comparisons (10 instead of 25)
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

    // Construct output with hardwired 1's for self-comparisons
    // and duplicated symmetric comparisons
    assign out = {
        {1'b1, ab,   ac,   ad,   ae},   // a row
        {ab,   1'b1, bc,   bd,   be},   // b row
        {ac,   bc,   1'b1, cd,   ce},   // c row
        {ad,   bd,   cd,   1'b1, de},   // d row
        {ae,   be,   ce,   de,   1'b1}  // e row
    };
endmodule