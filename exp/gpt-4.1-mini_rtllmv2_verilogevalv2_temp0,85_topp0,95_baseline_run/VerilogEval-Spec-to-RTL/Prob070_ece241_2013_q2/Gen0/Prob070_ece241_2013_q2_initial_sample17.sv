module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal sum-of-products expression
    assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

    // Minimal product-of-sums expression
    assign out_pos = (a | b | d) & (a | ~b | ~c) & (~a | b | c) & (~a | ~b | ~d);

endmodule