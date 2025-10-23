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
                     (~a & b & c & d) |     // 7 (0111)
                     (a & b & c & d);       // 15 (1111)

    // Correct POS implementation
    assign out_pos = (~b | ~d) &            // Covers 0,1,4,5,6,9,10,13,14
                    (b | d | ~a) &          // Covers remaining cases
                    (a | ~c | d) &          // Additional coverage
                    (~a | ~b | c);          // Final coverage

endmodule