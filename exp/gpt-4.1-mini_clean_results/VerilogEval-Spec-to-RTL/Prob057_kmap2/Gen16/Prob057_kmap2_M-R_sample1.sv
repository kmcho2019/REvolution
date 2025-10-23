module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Product terms from K-map groups:

    // Group 1: ~d & ~a
    wire term1 = (~d) & (~a);

    // Group 2: ~c & ~b
    wire term2 = (~c) & (~b);

    // Group 3: c & d & a
    wire term3 = c & d & a;

    // Group 4: c & d & b
    wire term4 = c & d & b;

    assign out = term1 | term2 | term3 | term4;
endmodule