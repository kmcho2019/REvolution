module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products (already minimal)
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d) |    // 7
                     (a & b & c & d);      // 15

    // Simplified Product-of-sums
    assign out_pos = (~c) &                // Covers all cases where c=0
                     (a | ~b | ~d) &      // Covers false cases when c=1
                     (a | b | c | ~d);    // Additional coverage for c=1 cases

endmodule