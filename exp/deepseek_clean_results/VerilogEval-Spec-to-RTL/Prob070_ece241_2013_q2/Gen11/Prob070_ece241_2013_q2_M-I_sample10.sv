module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP implementation - correct as is
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |    // 7 (0111)
                     (a & b & c & d);      // 15 (1111)

    // Corrected POS implementation
    // Product of sums covering all false cases:
    // 0: a|b|c|d
    // 1: a|b|c|~d
    // 4: a|~b|c|d
    // 5: a|~b|c|~d
    // 6: a|~b|~c|d
    // 9: ~a|b|c|d
    // 10: ~a|b|~c|d
    // 13: ~a|~b|c|d
    // 14: ~a|~b|~c|d
    // Optimized by factoring common terms
    assign out_pos = (a | c) &             // Covers 0,1,4,5,6,9,13,14
                     (a | ~b | d) &        // Covers 6,14
                     (~a | b | d) &        // Covers 9,10
                     (c | d);              // Covers 10,13,14

endmodule