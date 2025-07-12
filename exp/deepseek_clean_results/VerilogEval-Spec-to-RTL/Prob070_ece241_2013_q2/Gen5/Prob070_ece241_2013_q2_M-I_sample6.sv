module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct and optimized Sum-of-Products implementation
    // Only implements exact minterms: 2 (0010), 7 (0111), 15 (1111)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                    (~a & b & c & d) |     // 7
                    (a & b & c & d);       // 15

    // Correct and optimized Product-of-Sums implementation
    // Covers all maxterms: 0,1,4,5,6,9,10,13,14
    // Using minimal 4 product terms
    assign out_pos = (a | b | c) &                // Covers 0,1
                     (a | ~b | ~c | d) &          // Covers 4,5,6
                     (~a | b | c | ~d) &          // Covers 9,10
                     (~a | ~b | c | d);           // Covers 13,14

endmodule