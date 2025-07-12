module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized SOP implementation using don't-care conditions
    assign out_sop = (~a & ~b & c) |      // Combines 2 and don't-care 3
                    (~a & c & d) |       // Combines 7 and don't-care 11
                    (a & b & c & d);     // 15 remains

    // Optimized POS implementation using don't-care conditions
    assign out_pos = (a | b | c | d) &   // 0
                    (a | b | c) &        // Combines 1 and others
                    (a | ~b | c) &       // Combines 4,5
                    (a | ~b | ~c) &      // 6
                    (~a | b | d) &       // Combines 9,10 with don't-care 8
                    (~a | ~b | d);       // Combines 13,14 with don't-care 12

endmodule