module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Corrected Sum-of-products
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |    // 7 (0111)
                     (a & b & c & d);      // 15 (1111)

    // Corrected Product-of-sums
    assign out_pos = (~a | ~c) &           // Covers 0,1,4,5,9,13
                     (~a | b | ~d) &       // Covers 6,14
                     (a | ~b | d) &        // Covers 1,5,9,13
                     (a | ~b | ~c) &       // Covers 4,10
                     (a | b | ~d);         // Covers 6,10,14

endmodule