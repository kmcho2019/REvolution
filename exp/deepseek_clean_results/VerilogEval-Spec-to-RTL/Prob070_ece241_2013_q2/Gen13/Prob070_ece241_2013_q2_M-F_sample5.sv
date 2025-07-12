module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Corrected Sum-of-products implementation
    assign out_sop = (~a & ~b & c & ~d) |  // Covers only 2 (0010)
                     (~a & b & c & d)    |  // Covers only 7 (0111)
                     (a & b & c & d);       // Covers only 15 (1111)

    // Corrected Product-of-sums implementation
    assign out_pos = (a | b | c | d) &      // Covers 0 (0000)
                     (a | b | c | ~d) &     // Covers 1 (0001)
                     (a | ~b | c | d) &     // Covers 4 (0100)
                     (a | ~b | c | ~d) &     // Covers 5 (0101)
                     (a | ~b | ~c | d) &     // Covers 6 (0110)
                     (~a | b | c | ~d) &    // Covers 9 (1001)
                     (~a | b | ~c | d) &     // Covers 10 (1010)
                     (~a | ~b | c | ~d) &    // Covers 13 (1101)
                     (~a | ~b | ~c | d);     // Covers 14 (1110)

endmodule