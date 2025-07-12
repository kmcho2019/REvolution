module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Group 1: ~d & ~a
    wire p0 = ~d & ~a;

    // Group 2: ~c & ~b
    wire p1 = ~c & ~b;

    // Group 3: c & d & (a | b)
    wire p2 = c & d & (a | b);

    assign out = p0 | p1 | p2;
endmodule