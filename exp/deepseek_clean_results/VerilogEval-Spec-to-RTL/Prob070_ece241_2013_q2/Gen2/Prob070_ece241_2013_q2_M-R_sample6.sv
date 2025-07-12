module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products (minimal form)
    assign out_sop = (~a & ~b & c & ~d) |  // 2: 0010
                     (~a & b & c & d)   |  // 7: 0111
                     (a & b & c & d);      // 15: 1111

    // Product-of-sums (optimized form)
    assign out_pos = (a | b | c) &         // Combines terms for 0,1,4,5,6
                    (a | ~b | c) &        // Combines terms for 4,5,9,13
                    (a | ~b | ~c | d) &   // Term for 6
                    (~a | b | c | ~d) &   // Term for 9
                    (~a | b | ~c | d) &  // Term for 10
                    (~a | ~b | c | ~d) &  // Term for 13
                    (~a | ~b | ~c | d);   // Term for 14

endmodule