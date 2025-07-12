module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Optimized SOP implementation
    assign out_sop = (~a & c & ~d) |  // Covers 2 and can help with don't-cares
                    (b & c & d) |     // Covers 7
                    (a & b & c);      // Covers 15 and helps with don't-cares

    // Optimized POS implementation
    assign out_pos = c & 
                   (a | b | d) & 
                   (~a | b | ~d) & 
                   (a | ~b | d);

endmodule