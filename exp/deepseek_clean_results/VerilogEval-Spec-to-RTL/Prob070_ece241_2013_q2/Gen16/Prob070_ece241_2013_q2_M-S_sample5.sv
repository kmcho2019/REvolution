module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct SOP implementation
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |    // 7 (0111)
                     (a & b & c & d);       // 15 (1111)

    // Correct POS implementation
    assign out_pos = (a | b | c | d) &             // Covers 0000 (0)
                     (a | b | c | ~d) &            // Covers 0001 (1)
                     (a | ~b | c | d) &            // Covers 0100 (4)
                     (a | ~b | c | ~d) &           // Covers 0101 (5)
                     (a | ~b | ~c | d) &          // Covers 0110 (6)
                     (~a | b | c | d) &           // Covers 1001 (9)
                     (~a | b | ~c | d) &           // Covers 1010 (10)
                     (~a | ~b | c | ~d) &          // Covers 1101 (13)
                     (~a | ~b | ~c | d);          // Covers 1110 (14)

endmodule