module TopModule(
    input  [3:0] x,
    output       f
);

    // Input bits
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Shared complements
    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Term A: (~x1 | (x2 & ~x0)) -- from Example 2 factorization
    wire termA = nx1 | (x2 & nx0);

    // Term B: (~x0 | x1) -- from Example 1 minimal expression
    wire termB = nx0 | x1;

    // Final function:
    // f = (~x3 & termA) | (x3 & x2 & termB)
    assign f = (nx3 & termA) | (x3 & x2 & termB);

endmodule