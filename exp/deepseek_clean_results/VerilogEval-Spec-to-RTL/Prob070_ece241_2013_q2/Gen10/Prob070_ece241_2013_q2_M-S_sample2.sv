module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-products: direct implementation of true cases
    assign out_sop = (~a & b & ~c & d) |  // 2
                     (~a & b & c & d) |   // 7
                     (a & b & c & d);    // 15

    // Product-of-sums: De Morgan's of SOP
    assign out_pos = ~((~a & b & ~c & d) | (~a & b & c & d) | (a & b & c & d));

endmodule