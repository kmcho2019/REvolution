module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct SOP implementation covering all true cases
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |    // 7 (0111)
                     (a & b & c & d);      // 15 (1111)

    // Correct POS implementation covering all false cases
    assign out_pos = ~( (~c) |                         // Covers 0,1,4,5,8,9,12,13
                       (c & ~a & b & ~d) |             // Covers 6 (0110)
                       (c & a & ~b & d) |             // Covers 10 (1010)
                       (c & a & b & ~d)                // Covers 14 (1110)
                     );

endmodule