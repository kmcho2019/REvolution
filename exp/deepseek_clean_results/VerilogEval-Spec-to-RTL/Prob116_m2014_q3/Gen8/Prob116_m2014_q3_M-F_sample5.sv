module TopModule(
    input [3:0] x,  // x[3]x[0]x[1]x[2] mapping (assuming x[4] was typo for x[0])
    output f
);
    // Correct implementation of the K-map:
    // f = (x[3] & ~x[1]) |                     // Covers 11_00, 11_01, 10_00, 10_01
    //     (~x[3] & x[0] & x[1] & x[2]) |       // Covers 01_11
    //     (x[3] & x[0] & ~x[2]);               // Covers 11_01 (already covered by first term)
    
    // Optimized version (since 11_01 is covered by both first and third terms):
    assign f = (x[3] & ~x[1]) | (~x[3] & x[0] & x[1] & x[2]);

    // This covers all mandatory 1s in the K-map:
    // - All 1s in rows 11 and 10 when x[1] is 0
    // - The single 1 in row 01 when x[1]x[2] is 11
    // Don't-cares are treated as 0 for minimal implementation
endmodule