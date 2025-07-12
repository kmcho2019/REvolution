module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Simplified SOP implementation
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (b & c & d);           // 7 or 15 (x111)

    // Simplified POS implementation
    assign out_pos = (a | c) &             // Covers multiple 0-cases
                    (a | ~b | d) &         // Covers 4,5,6
                    (~a | b | ~d) &        // Covers 9,10,13
                    (~a | c | d);         // Covers 0,1,14

endmodule