module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct Sum-of-products implementation (unchanged as it was correct)
    assign out_sop = (~a & b & ~c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |     // 7 (0111)
                     (a & b & c & d);       // 15 (1111)

    // Corrected Product-of-sums implementation
    assign out_pos = (a | b | c | d) &      // Covers 0
                     (a | b | c | ~d) &     // Covers 1
                     (a | ~b | c | d) &     // Covers 4
                     (a | ~b | c | ~d) &    // Covers 5
                     (a | ~b | ~c | d) &   // Covers 6
                     (~a | b | c | d) &     // Covers 9
                     (~a | b | c | ~d) &    // Covers 10
                     (~a | ~b | c | d) &    // Covers 13
                     (~a | ~b | ~c | d);    // Covers 14

endmodule