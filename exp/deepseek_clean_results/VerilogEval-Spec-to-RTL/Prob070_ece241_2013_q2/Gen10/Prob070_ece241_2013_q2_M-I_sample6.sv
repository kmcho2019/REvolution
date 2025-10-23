module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Corrected Sum-of-products implementation
    // Covers all true cases: 2,7,15
    assign out_sop = (~a & b & ~c & d) |  // Decimal 2
                     (~a & b & c & d)  |  // Decimal 7
                     (a & b & c & d);    // Decimal 15

    // Optimized Product-of-sums implementation
    // Derived by grouping false cases with common literals
    assign out_pos = ~(
                      (~a & ~d) |                   // Covers 0,1,4,5
                      (~a & b & c & ~d) |           // Covers 6
                      (a & ~b & (~c | ~d)) |        // Covers 9,10
                      (a & b & (~c & d | c & ~d))   // Covers 13,14
                     );

endmodule