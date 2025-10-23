module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimal Sum-of-products (unchanged, already optimal)
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d)   |  // 7 (0111)
                     (a & b & c & d);      // 15 (1111)

    // Simplified Product-of-sums
    assign out_pos = (a | b | d) &         // Covers 0,1,4,5,6,13,14
                     (a | c | d) &        // Covers 0,1,9,10,13,14
                     (~a | b | c | ~d) &   // Covers 9,10,13
                     (~a | b | ~c | d);    // Covers 9,10,14

endmodule