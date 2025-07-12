module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products implementation using pattern matching
    // Minimized by combining terms 7 and 15 which share b & c & d
    assign out_sop = (~a & b & ~c & d) |  // Decimal 2
                     (b & c & d);         // Covers both 7 and 15 (with a as don't-care)

    // Product-of-sums implementation using maxterm optimization
    // Derived by ORing all false cases and applying De Morgan's laws
    assign out_pos = ~(
                      (~a & ~b & ~c & ~d) |  // 0
                      (~a & ~b & ~c & d)  |   // 1
                      (~a & b & ~c & ~d) |   // 4
                      (~a & b & ~c & d)  |   // 5
                      (~a & b & c & ~d)  |   // 6
                      (a & ~b & ~c & d)  |   // 9
                      (a & ~b & c & ~d)  |   // 10
                      (a & b & ~c & d)   |   // 13
                      (a & b & c & ~d)       // 14
                     );

endmodule