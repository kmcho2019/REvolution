module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation (minimal and correct)
    assign out_sop = (~a & ~b & c & ~d) |  // Decimal 2 (0010)
                     (~a & b & c & d) |    // Decimal 7 (0111)
                     (a & b & c & d);     // Decimal 15 (1111)

    // Corrected and optimized Product-of-sums implementation
    assign out_pos = (a | b | c | d) &                // Covers 0000(0)
                     (a | b | c | ~d) &               // Covers 0001(1)
                     (a | ~b | c) &                   // Covers 0100(4), 0101(5)
                     (a | ~b | ~c | d) &              // Covers 0110(6)
                     (~a | b | ~d) &                  // Covers 1001(9), 1101(13)
                     (~a | ~b | d);                   // Covers 1010(10), 1110(14)

endmodule