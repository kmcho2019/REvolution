module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Refactored Sum-of-products implementation
    // Explicitly list all true cases without term sharing
    assign out_sop = (~a &  b & ~c &  d) |  // Decimal 2
                     (~a &  b &  c &  d) |  // Decimal 7
                     ( a &  b &  c &  d);   // Decimal 15

    // Refactored Product-of-sums implementation using maxterms
    // Implemented as AND of OR terms (maxterms) for each false case
    assign out_pos = (a | b | c | d) &             // M0: ~0000
                     (a | b | c | ~d) &            // M1: ~0001
                     (a | ~b | c | d) &            // M4: ~0100
                     (a | ~b | c | ~d) &           // M5: ~0101
                     (a | ~b | ~c | d) &           // M6: ~0110
                     (~a | b | c | ~d) &           // M9: ~1001
                     (~a | b | ~c | d) &           // M10: ~1010
                     (~a | ~b | c | ~d) &          // M13: ~1101
                     (~a | ~b | ~c | d);           // M14: ~1110

endmodule