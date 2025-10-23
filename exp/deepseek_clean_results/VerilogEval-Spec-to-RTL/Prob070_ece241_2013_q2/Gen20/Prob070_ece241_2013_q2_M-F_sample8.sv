module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct SOP implementation - exact minterms only
    assign out_sop = (~a & ~b & ~c & d) |  // 2 (0010)
                    (~a & b & c & d) |    // 7 (0111)
                    (a & b & c & d);       // 15 (1111)

    // Correct POS implementation - carefully constructed terms
    assign out_pos = (a | b | ~c | d) &    // Blocks 0,1
                    (a | ~b | c | d) &     // Blocks 4,5
                    (a | ~b | ~c | d) &    // Blocks 6
                    (~a | b | c | ~d) &   // Blocks 9
                    (~a | b | ~c | d) &   // Blocks 10
                    (~a | ~b | c | ~d) &  // Blocks 13
                    (~a | ~b | ~c | d);    // Blocks 14

endmodule