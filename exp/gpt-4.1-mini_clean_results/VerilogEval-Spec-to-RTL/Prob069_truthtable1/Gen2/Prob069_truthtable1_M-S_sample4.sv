module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

    // From the truth table, f = (x2 & ~x3) | (x1 & x3) | (x2 & x1 & x3)
    // Simplify: f = (x2 & ~x3) | (x1 & x3)

    assign f = (x2 & ~x3) | (x1 & x3);

endmodule