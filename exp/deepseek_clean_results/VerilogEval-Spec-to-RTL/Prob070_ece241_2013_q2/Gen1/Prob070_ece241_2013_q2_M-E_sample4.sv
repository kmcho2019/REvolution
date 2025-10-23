module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-Products implementation using pattern matching
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |    // 7 (0111)
                     (a & b & c & d);      // 15 (1111)

    // Product-of-Sums implementation using complemented pattern matching
    // First create an intermediate signal that's 0 for all cases where output should be 0
    wire out_pos_intermediate;
    assign out_pos_intermediate = !((~a & ~b & ~c & ~d) |  // 0 (0000)
                                   (~a & ~b & ~c & d) |    // 1 (0001)
                                   (~a & b & ~c & ~d) |    // 4 (0100)
                                   (~a & b & ~c & d) |     // 5 (0101)
                                   (~a & b & c & ~d) |     // 6 (0110)
                                   (a & ~b & ~c & d) |     // 9 (1001)
                                   (a & ~b & c & ~d) |     // 10 (1010)
                                   (a & b & ~c & d) |      // 13 (1101)
                                   (a & b & c & ~d));      // 14 (1110)

    assign out_pos = out_pos_intermediate;

endmodule