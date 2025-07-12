module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Corrected Sum-of-products (direct implementation)
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d)   |  // 7 (0111)
                     (a & b & c & d);      // 15 (1111)

    // Corrected Product-of-sums (4 terms covering all false cases)
    assign out_pos = (a | b | c | ~d) &    // Covers 0 (0000), 1 (0001)
                     (a | b | ~c | d) &    // Covers 4 (0100), 5 (0101), 6 (0110)
                     (~a | b | c | ~d) &   // Covers 9 (1001), 10 (1010)
                     (~a | b | ~c | d);    // Covers 13 (1101), 14 (1110)

endmodule