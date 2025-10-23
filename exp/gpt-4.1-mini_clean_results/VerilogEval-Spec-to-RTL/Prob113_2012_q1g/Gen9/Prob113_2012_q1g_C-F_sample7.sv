module TopModule(
    input  [3:0] x,
    output       f
);

    // Assign input bits to named wires for clarity
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Minimal sum-of-products expression derived and factored from Karnaugh map:
    // f = (~x3 & ~x1) 
    //   | (x2 & x1 & ~x0 & ~x3) 
    //   | (x3 & x2 & (~x0 | (x1 & x0)));
    assign f = (~x3 & ~x1)
             | (x2 & x1 & ~x0 & ~x3)
             | (x3 & x2 & (~x0 | (x1 & x0)));

endmodule