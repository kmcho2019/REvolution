module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Mux-based SOP implementation
    assign out_sop = (~a & ~b) ? (~c & d) :  // When a=0,b=0: only 2 (0010) is true
                    (~a & b)  ? (c & d) :   // When a=0,b=1: only 7 (0111) is true
                    (a & ~b)   ? 1'b0 :      // When a=1,b=0: all are false (9,10)
                                (c & d);     // When a=1,b=1: only 15 (1111) is true

    // Mux-based POS implementation
    assign out_pos = (~a & ~b) ? (c | ~d) :  // When a=0,b=0: covers false cases 0,1
                    (~a & b)   ? (~c | ~d) : // When a=0,b=1: covers false cases 4,5,6
                    (a & ~b)   ? 1'b0 :      // When a=1,b=0: all are false (9,10)
                                (~c | ~d);   // When a=1,b=1: covers false cases 13,14

endmodule