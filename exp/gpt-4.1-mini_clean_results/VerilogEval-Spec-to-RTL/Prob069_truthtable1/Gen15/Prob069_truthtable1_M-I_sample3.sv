module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    // Minimal expression from truth table:
    // f = (~x3 & x2 & ~x1) | (x1 & (x2 | x3))
    assign f = (~x3 & x2 & ~x1) | (x1 & (x2 | x3));
endmodule