module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Refactored Sum-of-products implementation
    assign out_sop = (b & c & d) |          // Covers 7 (0111)
                     (a & b & c & d) |      // Covers 15 (1111)
                     (~a & b & ~c & d);     // Covers 2 (0010)

    // Refactored Product-of-sums implementation
    assign out_pos = (b | d) &              // Excludes 0,1,4,5,6,9,13,14
                     (~a | b | c) &         // Excludes 10
                     (a | ~b | ~d);         // Additional exclusion terms

endmodule