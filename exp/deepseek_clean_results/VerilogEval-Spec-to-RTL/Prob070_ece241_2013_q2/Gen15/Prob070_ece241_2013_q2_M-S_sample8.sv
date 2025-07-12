module TopModule (
    input  a, b, c, d,
    output out_sop,
    output out_pos
);

    // Simplified Sum of Products
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d) |    // 7
                     (a & b & c & d);      // 15

    // Simplified Product of Sums
    assign out_pos = ~(~a & ~b & ~c & ~d) &  // Not 0
                     ~(~a & ~b & ~c & d) &   // Not 1
                     ~(~a & b & ~c) &        // Not 4,5,6
                     ~(a & ~b & ~c) &        // Not 8,9
                     ~(a & ~b & c & ~d) &    // Not 10
                     ~(a & b & ~c & d) &     // Not 13
                     ~(a & b & c & ~d);     // Not 14

endmodule