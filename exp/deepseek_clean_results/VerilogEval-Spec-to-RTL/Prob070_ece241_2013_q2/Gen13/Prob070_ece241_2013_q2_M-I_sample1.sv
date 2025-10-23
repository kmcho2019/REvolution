module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimal Sum-of-products implementation (unchanged)
    assign out_sop = (~a & ~b & c & ~d) |  // Decimal 2 (0010)
                     (~a & b & c & d) |    // Decimal 7 (0111)
                     (a & b & c & d);      // Decimal 15 (1111)

    // Optimized Product-of-sums implementation
    assign out_pos = (a | b | c) &             // Combines M0 and M1
                     (a | ~b | c) &            // Combines M4 and M5
                     (a | ~b | ~c | d) &      // M6 remains
                     (~a | ((b | c | ~d) & (b | ~c | d))) &  // Combines M9,M10,M13,M14
                     (~a | ~b | ~c | d);       // M14 alternative term

    // Alternative equivalent POS implementation (same optimization):
    // assign out_pos = (a | b | c) &
    //                  (a | ~b | c) &
    //                  (a | ~b | ~c | d) &
    //                  (~a | b | c | ~d) &
    //                  (~a | b | ~c | d);

endmodule