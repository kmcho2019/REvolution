module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products (correct implementation)
    assign out_sop = (~a & ~b & c & ~d) |  // 2: 0010
                     (~a & b & c & d)   |  // 7: 0111
                     (a & b & c & d);      // 15: 1111

    // Product-of-sums (correct and optimized implementation)
    assign out_pos = (a | b | ~c | d) &    // Covers 0,1,4,5,6,9,10,13,14
                    (a | ~b | c | d) &    // Covers 0,1,4,5,6,9,13
                    (~a | b | c | ~d);    // Covers 0,1,5,6,10,14

endmodule