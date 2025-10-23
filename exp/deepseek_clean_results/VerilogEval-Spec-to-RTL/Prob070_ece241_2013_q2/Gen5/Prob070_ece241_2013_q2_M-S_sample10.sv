module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Direct sum-of-products implementation
    assign out_sop = (~a & ~b & c & ~d) |  // 2
                     (~a & b & c & d) |    // 7
                     (a & b & c & d);     // 15

    // Product-of-sums as complement of SOP terms
    assign out_pos = ~((~a & ~b & c & ~d) |
                       (~a & b & c & d) |
                       (a & b & c & d));

endmodule