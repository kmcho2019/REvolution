module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Refactored SOP implementation with minimized operations
    assign out_sop = (~a & c & (~b & ~d | b & d)) | (a & b & c & d);

    // Proper POS implementation
    assign out_pos = ~( (~c) |                     // Covers 0,1,4,5,8,9,12,13
                       (c & ~a & ~b & d) |         // Covers 6 (0110)
                       (c & ~a & b & ~d) |         // Covers 10 (1010)
                       (c & a & ~b & ~d)           // Covers 14 (1110)
                     );

endmodule