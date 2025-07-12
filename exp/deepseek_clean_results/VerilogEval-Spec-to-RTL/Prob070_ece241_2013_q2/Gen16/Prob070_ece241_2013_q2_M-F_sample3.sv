module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP implementation (correct as is)
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |     // 7 (0111)
                     (a & b & c & d);        // 15 (1111)

    // Optimized POS implementation
    // Only need to ensure we don't match any false cases
    // Don't-cares (3,8,11,12) are implicitly allowed
    assign out_pos = ~(~a & ~b & ~c & ~d) &  // Not 0
                     ~(~a & ~b & ~c & d) &   // Not 1
                     ~(~a & b & ~c & ~d) &   // Not 4
                     ~(~a & b & ~c & d) &    // Not 5
                     ~(~a & b & c & ~d) &    // Not 6
                     ~(a & ~b & ~c & d) &    // Not 9
                     ~(a & ~b & c & ~d) &    // Not 10
                     ~(a & b & ~c & d) &     // Not 13
                     ~(a & b & c & ~d);      // Not 14

endmodule