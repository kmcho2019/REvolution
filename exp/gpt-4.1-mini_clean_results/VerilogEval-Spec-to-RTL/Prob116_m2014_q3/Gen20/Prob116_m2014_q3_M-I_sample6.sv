module TopModule (
    input  [3:0] x,  // x = {x4,x3,x2,x1}
    output       f
);
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Original K-map given with rows = x3x4 and cols = x1x2 (Gray code)
    // The rows and cols are Gray encoded; to avoid XOR, use bits directly.
    // Using Gray code bits as inputs, derive minimal SOP for f:
    //
    // K-map from problem (for rows x3x4, cols x1x2):
    //
    //       x1x2
    // x3x4 00  01  11  10
    // 00   d=0 0   d=0 d=0
    // 01    0 d=0 1   0
    // 11    1  1  d=0 d=0
    // 10    1  1   0  d=0
    //
    // Interpreting don't-cares as zeros for safety here but exploiting them for simplification.
    //
    // From map and variables x4 x3 | x2 x1:
    // Express f in SOP form simplified with Karnaugh map:

    // Minimal SOP found by grouping:
    // f = x4'x3 + x3 x2' + x4 x1

    // Explanation:
    // - Group ones in rows 11 and 10 (x4x3=11 or 10): both have f=1 when x1=1 or x2=0 accordingly
    // - The expression covers all 1s in the map with minimal terms.

    assign f = (~x4 & x3) | (x3 & ~x2) | (x4 & x1);

endmodule