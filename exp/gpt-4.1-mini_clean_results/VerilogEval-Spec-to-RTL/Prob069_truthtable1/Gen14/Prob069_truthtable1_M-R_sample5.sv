module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

    wire and_term; // ~x3 & x2
    wire or_term;  // x3 | x2

    assign and_term = (~x3) & x2;
    assign or_term  = x3 | x2;
    assign f = x1 ? or_term : and_term;

endmodule