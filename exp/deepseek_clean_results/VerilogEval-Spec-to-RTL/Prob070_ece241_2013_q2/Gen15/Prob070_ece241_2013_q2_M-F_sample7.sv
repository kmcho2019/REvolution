module TopModule (
    input  a, b, c, d,
    output out_sop,
    output out_pos
);

    // Correct Sum of Products implementation
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |     // 7 (0111)
                     (a & b & c & d);       // 15 (1111)

    // Correct Product of Sums implementation
    assign out_pos = (a | b | c | d) &         // Covers 0000,0001
                     (a | b | ~c | d) &        // Covers 0100,0101
                     (a | ~b | c | ~d) &      // Covers 0110
                     (~a | b | c | d) &        // Covers 1001
                     (~a | b | ~c | ~d) &      // Covers 1010
                     (~a | ~b | c | d) &       // Covers 1101
                     (~a | ~b | ~c | d);       // Covers 1110

endmodule