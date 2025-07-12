module TopModule (
    input  a, b, c, d,
    output out_sop,
    output out_pos
);

    // Optimized Sum of Products using don't-care conditions
    assign out_sop = (~a & c & ~d) |  // Covers 2 and can expand to some don't-cares
                     (b & c & d);     // Covers 7 and 15

    // Optimized Product of Sums using don't-care conditions
    assign out_pos = (a | c) &                // Covers 0,1,4,5
                     (a | ~b | d) &           // Covers 6,9
                     (~a | b | ~d) &          // Covers 10,13
                     (~a | ~b | ~c);          // Covers 14

endmodule