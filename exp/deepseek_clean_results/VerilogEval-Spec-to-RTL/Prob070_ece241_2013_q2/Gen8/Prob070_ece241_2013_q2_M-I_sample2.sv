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
                     (~a & b & c & d) |     // 7 (0111)
                     (a & b & c & d);       // 15 (1111)

    // Correct Product-of-sums implementation
    assign out_pos = (~b | ~c | ~d) &              // Blocks 0,1,4,5 (0000,0001,0100,0101)
                     (a | ~b | ~c) &                // Blocks 6,14 (0110,1110)
                     (~a | b | ~c | d) &            // Blocks 9,13 (1001,1101)
                     (a | b | ~c | ~d);             // Blocks 10 (1010)

endmodule