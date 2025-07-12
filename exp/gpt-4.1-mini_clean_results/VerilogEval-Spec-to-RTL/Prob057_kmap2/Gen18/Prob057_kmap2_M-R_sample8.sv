module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Shared inverted inputs to reduce logic duplication
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Group 1: (~c & ~d & (~a | ~b))
    wire group1 = nc & nd & (na | nb);

    // Group 2: (~c & d & ~b)
    wire group2 = nc & d & nb;

    // Group 3: (c & ~d & ~a)
    wire group3 = c & nd & na;

    // Group 4: (c & d & (a | b)) - combined in one expression directly
    wire group4 = c & d & (a | b);

    // Final output is OR of all groups
    assign out = group1 | group2 | group3 | group4;

endmodule