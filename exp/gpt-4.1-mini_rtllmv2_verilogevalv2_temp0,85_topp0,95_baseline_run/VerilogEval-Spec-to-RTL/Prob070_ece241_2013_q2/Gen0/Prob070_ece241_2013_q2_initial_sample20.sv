module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal Sum of Products (SOP):
    // out_sop = a' b' c d' + a' b c d + a b c d
    assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Minimal Product of Sums (POS):
    // out_pos = (a + b + d)(a + b' + c' + d')(a' + b + c + d')
    assign out_pos = (a | b | d) & (a | ~b | ~c | ~d) & (~a | b | c | ~d);

endmodule