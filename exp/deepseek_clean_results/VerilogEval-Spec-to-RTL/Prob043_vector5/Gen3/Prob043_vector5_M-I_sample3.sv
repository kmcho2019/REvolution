module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Compute unique pairwise comparisons (10 operations)
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
        // a row (self-comparison is always 1)
        1'b1, ab,   ac,   ad,   ae,
        // b row (symmetric)
        ab,   1'b1, bc,   bd,   be,
        // c row (symmetric)
        ac,   bc,   1'b1, cd,   ce,
        // d row (symmetric)
        ad,   bd,   cd,   1'b1, de,
        // e row (symmetric)
        ae,   be,   ce,   de,   1'b1
    };

endmodule