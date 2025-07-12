module TopModule (
    input  [3:0] x, // x[3] = x4, x[2] = x3, x[1] = x2, x[0] = x1 (problem notation)
    output      f
);

    wire x1 = x[0]; // problem x[1]
    wire x2 = x[1]; // problem x[2]
    wire x3 = x[2]; // problem x[3]
    wire x4 = x[3]; // problem x[4]

    // Factored logic:
    // f = (x3 & ~x1) | (~x3 & x4 & x1 & x2);

    assign f = (x3 & ~x1) | (~x3 & x4 & x1 & x2);

endmodule