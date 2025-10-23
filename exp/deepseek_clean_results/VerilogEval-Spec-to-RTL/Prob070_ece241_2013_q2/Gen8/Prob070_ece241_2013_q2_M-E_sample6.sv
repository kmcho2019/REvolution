module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation
    // Minimized by combining terms and using don't-cares
    assign out_sop = (~a & b & ~c & d) |  // 2 (0010) when considering don't-cares
                     (b & c & d) |        // Covers 7 (0111) and some don't-cares
                     (a & b & c & d);     // 15 (1111)

    // Product-of-sums implementation
    // Minimized by finding common factors in false cases
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