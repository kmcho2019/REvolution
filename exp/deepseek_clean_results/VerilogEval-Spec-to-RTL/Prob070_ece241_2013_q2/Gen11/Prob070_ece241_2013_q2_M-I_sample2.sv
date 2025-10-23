module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct Sum-of-products implementation
    assign out_sop = (~a & b & ~c & d) |  // Decimal 2 (0010)
                     (~a & b & c & d)  |  // Decimal 7 (0111)
                     (a & b & c & d);     // Decimal 15 (1111)

    // Optimized Product-of-sums implementation
    assign out_pos = (a | ~b | ~c | d) &       // Covers 0,1,4,5
                     (a | ~b | c | d) &        // Covers 6
                     (~a | b | c | ~d) &       // Covers 9
                     (~a | b | ~c | d) &       // Covers 10
                     (~a | ~b | c | ~d);       // Covers 13,14

endmodule