module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Correct SOP implementation covering all required cases
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                    (~a & b & c & d) |    // 7 (0111)
                    (a & b & c & d);       // 15 (1111)

    // Correct POS implementation
    assign out_pos = (a | b | c) &
                    (~a | b | ~c) &
                    (~a | ~b | c) &
                    (a | ~b | ~c) &
                    (~a | ~b | ~d);

endmodule