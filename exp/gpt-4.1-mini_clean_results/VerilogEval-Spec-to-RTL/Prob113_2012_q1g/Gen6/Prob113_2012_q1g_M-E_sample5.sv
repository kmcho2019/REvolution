module TopModule(
    input  [3:0] x,
    output f
);
    wire A = x[0];
    wire B = x[1];
    wire C = x[2];
    wire D = x[3];

    // Karnaugh Map Analysis:
    // Given the rows = CD and columns = AB,
    // The map is:
    // CD\AB  00  01  11  10
    // 00     1   0   0   1
    // 01     0   0   0   0
    // 11     1   1   1   0
    // 10     1   1   0   1
    //
    // From grouping 1s in the K-map, minimal SOP is:
    // f = (~C & ~D & ~B) | (~C & ~D & A) | (C & D & ~B) | (C & ~D & ~B) | (C & D & A) | (~C & D & ~A & ~B)
    // This can be simplified further:
    // f = (~C & ~D & (A | ~B)) | (C & ~B) | (C & D & A) | (~C & D & ~A & ~B)
    // Notice (C & ~B) covers (C & ~D & ~B) and (C & D & ~B)
    // Thus final simplified form:
    // f = (~C & ~D & (A | ~B)) | (C & ~B) | (C & D & A) | (~C & D & ~A & ~B)
    //
    // The last term (~C & D & ~A & ~B) is isolated and must be included.

    wire term1 = (~C & ~D) & (A | ~B);
    wire term2 = C & ~B;
    wire term3 = C & D & A;
    wire term4 = ~C & D & ~A & ~B;

    assign f = term1 | term2 | term3 | term4;

endmodule