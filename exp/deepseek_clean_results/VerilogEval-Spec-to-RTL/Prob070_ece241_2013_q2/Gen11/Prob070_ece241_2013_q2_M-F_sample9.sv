module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Corrected Sum-of-products implementation
    // Only true for decimal 2 (0010), 7 (0111), and 15 (1111)
    assign out_sop = (~a & ~b & c & ~d) |  // Decimal 2 (0010)
                     (~a & b & c & d) |     // Decimal 7 (0111)
                     (a & b & c & d);       // Decimal 15 (1111)

    // Corrected Product-of-sums implementation
    // Covers all false cases (0,1,4,5,6,9,10,13,14)
    assign out_pos = (a | b | c | d) &             // M0: ~0000 (0)
                     (a | b | c | ~d) &            // M1: ~0001 (1)
                     (a | ~b | c | d) &            // M4: ~0100 (4)
                     (a | ~b | c | ~d) &           // M5: ~0101 (5)
                     (a | ~b | ~c | d) &           // M6: ~0110 (6)
                     (~a | b | c | ~d) &           // M9: ~1001 (9)
                     (~a | b | ~c | d) &           // M10: ~1010 (10)
                     (~a | ~b | c | ~d) &          // M13: ~1101 (13)
                     (~a | ~b | ~c | d);           // M14: ~1110 (14)

endmodule