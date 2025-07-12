module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP implementation remains the same (minimal form)
    assign out_sop = (~a & ~b & c & ~d) |  // 2 (0010)
                     (~a & b & c & d) |    // 7 (0111)
                     (a & b & c & d);       // 15 (1111)

    // Refactored POS implementation using optimized grouping
    // Group terms by common patterns to minimize logic
    assign out_pos = ~(~a & ~b & ~c & (d | ~d)) &  // Combines 0 and 1 cases
                     ~(~a & b & ~c & (d | ~d)) &   // Combines 4 and 5 cases
                     ~(~a & b & c & ~d) &          // 6 case
                     ~(a & ~b & (~c & d | c & ~d)) & // Combines 9 and 10 cases
                     ~(a & b & (~c & d | c & ~d));   // Combines 13 and 14 cases

endmodule