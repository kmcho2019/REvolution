module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimal Sum-of-products
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d)   |  // 7 (0111)
                     (a & b & c & d);     // 15 (1111)

    // Minimal Product-of-sums
    assign out_pos = (c) &                 // Covers 0,1,4,5,6,9,13
                     (b | d) &             // Covers 10,14
                     (~b | ~d | a);        // Additional coverage

endmodule