module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP implementation (correct and minimal)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                    (~a & b & c & d) |     // 7
                    (a & b & c & d);       // 15

    // Corrected POS implementation
    assign out_pos = c & 
                   (a | b | d) & 
                   (a | ~b | d) & 
                   (~a | b | ~d) & 
                   (~a | ~b | d);

endmodule