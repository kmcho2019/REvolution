module TopModule(
    input  [3:0] x,
    output      f
);
    // Assuming the Karnaugh map rows indexed by {x[3], x[0]}
    // and columns indexed by {x[1], x[2]}, matching the problem description.
    //
    // f = (x3 & x0) + (x3 & x2) + (x1 & x2 & ~x0)

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    assign f = (x3 & x0) | (x3 & x2) | (x1 & x2 & ~x0);

endmodule