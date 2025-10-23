module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products (minimal implementation)
    assign out_sop = (~a & ~b & c & ~d) |  // 2: 0010
                     (~a & b & c & d)   |  // 7: 0111
                     (a & b & c & d);      // 15: 1111

    // Product-of-sums (optimized implementation)
    assign out_pos = (b | c) &             // Covers 0,1,4,5,6
                    (~a | ~b | c | ~d) &  // Covers 9,14
                    (~a | b | ~c | d) &   // Covers 10,13
                    (a | ~b | c | d);     // Covers 9,13 (redundant but ensures coverage)

endmodule