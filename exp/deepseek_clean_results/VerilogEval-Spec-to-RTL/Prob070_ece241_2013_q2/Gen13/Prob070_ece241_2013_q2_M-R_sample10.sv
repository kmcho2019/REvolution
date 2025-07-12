module TopModule (
    input  a, b, c, d,
    output out_sop,
    output out_pos
);

    // Sum of Products - cleaner implementation
    assign out_sop = (~a & ~b &  c & ~d) |  // 2
                     (~a &  b &  c &  d) |  // 7
                     ( a &  b &  c &  d);    // 15

    // Product of Sums - better organized
    assign out_pos = (a | b | c | d)   & (a | b | c | ~d)  &  // 0,1
                     (a | ~b | c | d)  & (a | ~b | c | ~d) &  // 4,5
                     (a | ~b | ~c | d) &                     // 6
                     (~a | b | c | ~d) & (~a | b | ~c | d) &  // 9,10
                     (~a | ~b | c | ~d) & (~a | ~b | ~c | d); // 13,14

endmodule