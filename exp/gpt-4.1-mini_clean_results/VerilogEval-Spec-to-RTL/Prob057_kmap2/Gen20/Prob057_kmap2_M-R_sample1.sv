module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Compute inverted signals once
    wire not_a = ~a;
    wire not_b = ~b;
    wire not_c = ~c;
    wire not_d = ~d;

    // term1: ~c & ~d & (~a | ~b)
    wire term1 = not_c & not_d & (not_a | not_b);

    // term2: ~c & d & ~b
    wire term2 = not_c & d & not_b;

    // term3: c & ~d & ~a
    wire term3 = c & not_d & not_a;

    // term4: c & d & (a | b)
    wire term4 = c & d & (a | b);

    assign out = term1 | term2 | term3 | term4;
endmodule