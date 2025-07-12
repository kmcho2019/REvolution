module TopModule (
    input  a, b, c, d, e,
    output [24:0] out
);

    // Intermediate signals for unique comparisons
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
        /* a comparisons */ {1'b1, ab,   ac,   ad,   ae},   // a~^a is always 1
        /* b comparisons */ {ab,   1'b1, bc,   bd,   be},   // b~^b is always 1
        /* c comparisons */ {ac,   bc,   1'b1, cd,   ce},   // c~^c is always 1
        /* d comparisons */ {ad,   bd,   cd,   1'b1, de},   // d~^d is always 1
        /* e comparisons */ {ae,   be,   ce,   de,   1'b1}  // e~^e is always 1
    };

endmodule