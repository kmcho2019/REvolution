module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire term1, term2, term3, term4, term5;

    assign term1 = ~c & ~d & (~a | ~b);
    assign term2 = ~c & d & ~b;
    assign term3 = c & d & (a | b);
    assign term4 = c & ~d & ~a;

    assign out = term1 | term2 | term3 | term4;

endmodule