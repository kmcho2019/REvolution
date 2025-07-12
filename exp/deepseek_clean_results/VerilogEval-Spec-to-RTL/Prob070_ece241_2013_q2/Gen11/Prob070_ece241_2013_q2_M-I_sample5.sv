module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP implementation (correct and minimal)
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |    // 7 (0111)
                     (a & b & c & d);      // 15 (1111)

    // Corrected POS implementation
    assign out_pos = (~c) &                                // Covers 0,1,4,5
                    ~(~a & b & c & ~d) &                   // Covers 6
                    ~(a & ~b & ~c & d) &                   // Covers 9
                    ~(a & ~b & c & ~d) &                  // Covers 10
                    ~(a & b & ~c & d) &                   // Covers 13
                    ~(a & b & c & ~d);                    // Covers 14

endmodule