module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire term1 = ~d & ~a;
    wire term2 = ~c & ~b;
    wire term3 = c & d & (a | b);

    assign out = term1 | term2 | term3;
endmodule