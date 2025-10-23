module TopModule (
    input  a, b, c, d,
    output out_sop,
    output out_pos
);

    // Optimized Sum of Products using don't-cares
    assign out_sop = (~a & c & ~d) |  // Covers 2 (0010) and don't-care 3 (0011)
                     (b & c & d);      // Covers 7 (0111) and 15 (1111)

    // Optimized Product of Sums using don't-cares
    assign out_pos = (a | b | c) &        // Covers 0,1,4,5,8,9
                     (a | c | d) &         // Covers 0,1,4,6,8,10
                     (a | ~b | ~c) &       // Covers 5,6,13,14
                     (~a | b | ~d) &       // Covers 9,10,13
                     (~a | ~b | d);        // Covers 9,10,14

endmodule