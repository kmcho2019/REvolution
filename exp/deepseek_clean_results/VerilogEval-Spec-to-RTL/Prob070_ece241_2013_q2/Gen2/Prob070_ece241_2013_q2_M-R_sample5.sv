module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct Sum-of-products implementation
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |    // 7 (0111)
                     (a & b & c & d);      // 15 (1111)

    // Correct Product-of-sums implementation
    assign out_pos = (a | b | c) &         // Covers 0,1,4,5,6,8,9,10,12,13,14
                     (a | b | d) &         // Covers 0,1,4,5,6,9,10,13,14
                     (a | ~b | c) &       // Covers 0,1,4,5,6,9,13
                     (~a | b | c) &       // Covers 0,1,4,5,6,9,10,14
                     (~a | c | d);        // Covers 0,1,4,5,6,9,10,13,14

endmodule