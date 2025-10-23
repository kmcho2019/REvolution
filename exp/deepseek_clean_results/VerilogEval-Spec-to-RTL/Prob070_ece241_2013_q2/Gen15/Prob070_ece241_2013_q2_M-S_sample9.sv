module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation (already minimal)
    assign out_sop = (~a & ~b & c & ~d) |  // Decimal 2 (0010)
                     (~a & b & c & d) |    // Decimal 7 (0111)
                     (a & b & c & d);      // Decimal 15 (1111)

    // Optimized Product-of-sums implementation (3 terms)
    assign out_pos = (~a | ~d) &          // Covers 0,1,4,5,8,9,12,13
                     (~b | d) &            // Covers 0,2,4,6,8,10,12,14
                     (~a | ~b | ~c);       // Covers 0,1,2,3,4,5,6,8,9,10,11,12,13,14

endmodule