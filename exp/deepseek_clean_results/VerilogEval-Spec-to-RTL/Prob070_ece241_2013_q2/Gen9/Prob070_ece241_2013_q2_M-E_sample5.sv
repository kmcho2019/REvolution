module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation
    assign out_sop = (~a & ~b & c & ~d) |  // Term for 2 (0010)
                     (b & c & d);           // Combined term for 7 (0111) and 15 (1111)

    // Product-of-sums implementation
    assign out_pos = (a | b | c) &                 // Covers 0,1,4,5
                     (a | ~b | ~c | d) &           // Covers 6,9,14
                     (~a | b | ~c | ~d) &          // Covers 10,13
                     (~a | ~b | c | d);            // Covers 4,5,13

endmodule