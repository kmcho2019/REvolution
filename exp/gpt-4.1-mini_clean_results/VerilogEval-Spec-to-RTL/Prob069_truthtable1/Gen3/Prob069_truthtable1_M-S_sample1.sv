module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

    // Implement the function based on the truth table using a continuous assignment
    assign f = (~x3 & x2) | (x3 & x1);

endmodule