module TopModule(
    input  [3:0] x,
    output       f
);

    // For clarity, assign input bits to named signals
    wire x0 = x[0];
    wire x1 = x[1];
    wire x2 = x[2];
    wire x3 = x[3];

    // From the Karnaugh map, minimal logic can be deduced:
    // f = (~x2 & ~x3 & (~x0 | x1)) 
    //   | ( x2 &  x3)
    //   | ( x2 & ~x3 & ~x1)
    //   | (~x2 &  x3 & ~x0 & ~x1);

    assign f = 
        (~x2 & ~x3 & (~x0 | x1)) |
        ( x2 &  x3) |
        ( x2 & ~x3 & ~x1) |
        (~x2 &  x3 & ~x0 & ~x1);

endmodule