module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Simplified Sum-of-Products
    assign out_sop = (~a & c & ~d) |  // Covers 2 (0010) and don't-cares
                     (b & c & d) |    // Covers 7 (0111)
                     (a & b & c);     // Covers 15 (1111) and don't-cares

    // Simplified Product-of-Sums
    assign out_pos = (a | c | d) &        // Covers 0,4 and don't-cares
                     (a | c | ~d) &       // Covers 1,5 and don't-cares
                     (~a | b | c) &       // Covers 9,13 and don't-cares
                     (~a | ~b | d);       // Covers 6,10,14 and don't-cares

endmodule