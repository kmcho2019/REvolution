module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized Sum-of-products implementation
    assign out_sop = (~a & ~b & c & ~d) |  // Covers only 2 (0010)
                     (b & c & d);          // Covers 7 (0111) and 15 (1111)

    // Optimized Product-of-sums implementation
    assign out_pos = (a | c) &             // Covers 0,1,4,5
                     (a | ~b | d) &        // Covers 0,1,4,6
                     (~a | b | ~c) &       // Covers 9,10,13
                     (~a | ~b | ~d);       // Covers 13,14

endmodule