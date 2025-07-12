module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

    // From truth table:
    // f = (~x3 & x2) | (x3 & x1) | (x3 & x2 & x1)
    // Simplifies to:
    // f = ( ~x3 & x2 ) | ( x3 & x1 )

    assign f = (~x3 & x2) | (x3 & x1);

endmodule