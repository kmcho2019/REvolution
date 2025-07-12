module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products: OR of minterms (2,7,15)
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                    (~a & b & c & d) |    // 7 (0111)
                    (a & b & c & d);       // 15 (1111)

    // Product-of-sums: AND of maxterms (complements of 0,1,4,5,6,9,10,13,14)
    assign out_pos = (a | b | c | d) &                // ~0
                     (a | b | c | ~d) &              // ~1
                     (a | ~b | c | d) &              // ~4
                     (a | ~b | c | ~d) &             // ~5
                     (a | ~b | ~c | d) &             // ~6
                     (~a | b | c | d) &              // ~9
                     (~a | b | c | ~d) &             // ~10
                     (~a | ~b | c | d) &             // ~13
                     (~a | ~b | ~c | d);            // ~14

endmodule