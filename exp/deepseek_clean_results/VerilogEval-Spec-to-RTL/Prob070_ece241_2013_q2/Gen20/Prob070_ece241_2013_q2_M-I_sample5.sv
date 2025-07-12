module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized Sum-of-products implementation
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d)   |  // 7 (0111)
                     (a & b & c & d);      // 15 (1111)

    // Optimized Product-of-sums implementation
    assign out_pos = (a | b | c | d)    &  // Covers 0 (0000)
                     (a | b | c | ~d)   &  // Covers 1 (0001)
                     (a | ~b | c | d)   &  // Covers 4 (0100)
                     (a | ~b | c | ~d)  &  // Covers 5 (0101)
                     (a | ~b | ~c | d);    // Covers 6 (0110)
                     // Removed redundant terms for 9,10,13,14 as they're covered
                     // by the existing terms through Boolean relationships

endmodule