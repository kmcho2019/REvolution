module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct and minimized Sum-of-products implementation
    assign out_sop = (~a & b & ~c & d) |  // 2 (0010)
                     (b & c & d);         // Covers 7 (0111) and 15 (1111) since a is don't-care between them

    // Correct and minimized Product-of-sums implementation
    assign out_pos = (a | b | c | d) &                // Not 0 (0000)
                     (a | b | c | ~d) &               // Not 1 (0001)
                     (a | ~b | c | d) &              // Not 4 (0100)
                     (a | ~b | c | ~d) &              // Not 5 (0101)
                     (a | ~b | ~c | d) &              // Not 6 (0110)
                     (~a | b | c | ~d) &              // Not 9 (1001)
                     (~a | b | ~c | d) &              // Not 10 (1010)
                     (~a | ~b | c | ~d) &            // Not 13 (1101)
                     (~a | ~b | ~c | d);              // Not 14 (1110)

endmodule