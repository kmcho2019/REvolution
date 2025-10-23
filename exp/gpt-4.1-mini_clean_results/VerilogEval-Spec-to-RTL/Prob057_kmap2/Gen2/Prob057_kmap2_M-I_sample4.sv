module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire term1, term2, term3, term4, term5, term6;

    assign term1 = (~c) & (~d);
    assign term2 = c & (~d) & (~a);
    assign term3 = c & d & a;
    assign term4 = c & d & b;
    assign term5 = (~c) & d & (~a) & (~b);
    assign term6 = (~c) & d & a & (~b);

    assign out = term1 | term2 | term3 | term4 | term5 | term6;

endmodule