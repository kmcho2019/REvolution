module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Inverted signals for reuse
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Shared OR sub-expressions
    wire or_ab  = a | b;
    wire or_nab = na | nb;

    // Minimal SOP terms derived from K-map:
    // 1) ~c & ~d & (~a | ~b)
    // 2) ~c & d  & ~b
    // 3) c  & ~d & ~a
    // 4) c  & d  & (a | b)
    assign out =
          (nc & nd & or_nab)
        | (nc & d  & nb)
        | (c  & nd & na)
        | (c  & d  & or_ab);

endmodule