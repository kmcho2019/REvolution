module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // From K-map analysis and original groups:

    // Group 1: ~d & ~a
    wire group1 = (~d) & (~a);

    // Group 2: ~c & ~b
    wire group2 = (~c) & (~b);

    // Group 3: c & d & a
    wire group3a = c & d & a;

    // Group 4: c & d & b
    wire group3b = c & d & b;

    assign out = group1 | group2 | group3a | group3b;

endmodule