module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Compute terms
    wire term1 = ~d & (~a | ~c);
    wire term2 = c & d & (a | b);
    assign out = term1 | term2;
endmodule