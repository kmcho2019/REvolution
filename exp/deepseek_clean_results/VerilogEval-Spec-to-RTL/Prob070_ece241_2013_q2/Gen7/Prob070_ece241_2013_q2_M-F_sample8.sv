module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized Sum-of-products implementation
    assign out_sop = (~a & ~b & c) |  // Covers 2 (0010) and don't-care 3 (0011)
                     (b & c & d);      // Covers 7 (0111) and 15 (1111)

    // Optimized Product-of-sums implementation
    assign out_pos = (a | b | c) &             // Covers 0,1,4,5,6
                     (a | c | d) &              // Covers 0,4,6,10,14
                     (~a | ~b | ~c | ~d);      // Covers 9,13

endmodule