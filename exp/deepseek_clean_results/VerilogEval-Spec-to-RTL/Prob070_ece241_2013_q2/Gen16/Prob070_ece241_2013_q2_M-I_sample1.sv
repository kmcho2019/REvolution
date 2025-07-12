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
    assign out_pos = ~(~a & ~b & ~c & ~d) &  // Not 0 (0000)
                     ~(~a & ~b & ~c & d) &   // Not 1 (0001)
                     ~(~a & b & ~c & ~d) &  // Not 4 (0100)
                     ~(~a & b & ~c & d) &    // Not 5 (0101)
                     ~(~a & b & c & ~d) &    // Not 6 (0110)
                     ~(a & ~b & ~c & ~d) &  // Not 8 (1000) - don't care but included for safety
                     ~(a & ~b & ~c & d) &    // Not 9 (1001)
                     ~(a & ~b & c & ~d) &    // Not 10 (1010)
                     ~(a & b & ~c & d) &     // Not 13 (1101)
                     ~(a & b & c & ~d);      // Not 14 (1110)

endmodule