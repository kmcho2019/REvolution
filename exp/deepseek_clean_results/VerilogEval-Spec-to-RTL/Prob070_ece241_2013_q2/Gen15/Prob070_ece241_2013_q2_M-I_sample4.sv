module TopModule (
    input  a, b, c, d,
    output out_sop,
    output out_pos
);

    // Correct Sum of Products implementation
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |    // 7 (0111)
                     (a & b & c & d);       // 15 (1111)

    // Correct Product of Sums implementation
    assign out_pos = (a | b | c) &          // Covers 0,1
                     (a | ~b | c) &         // Covers 4,5,6
                     (~a | b | ~d) &        // Covers 9,10
                     (~a | ~b | d);        // Covers 13,14

endmodule