module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire term1, term2, term3;

    // Group 1: ~d & ~a
    assign term1 = (~d) & (~a);

    // Group 2: ~c & ~b
    assign term2 = (~c) & (~b);

    // Group 3: c & d & (a | b)
    assign term3 = c & d & (a | b);

    assign out = term1 | term2 | term3;
endmodule