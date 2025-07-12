module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Shared inverted inputs for reuse
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Term A: (~c & ~d & (~a | ~b)) = nc & nd & (na | nb)
    wire termA = nc & nd & (na | nb);

    // Term B: (~c & d & ~b) = nc & d & nb
    wire termB = nc & d & nb;

    // Term C: (c & ~d & ~a) = c & nd & na
    wire termC = c & nd & na;

    // Term D: (c & d & (a | b)) = c & d & (a | b)
    wire termD = c & d & (a | b);

    assign out = termA | termB | termC | termD;

endmodule