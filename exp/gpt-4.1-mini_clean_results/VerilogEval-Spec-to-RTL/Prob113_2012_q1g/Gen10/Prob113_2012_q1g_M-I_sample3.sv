module TopModule(
    input  [3:0] x,
    output f
);
    // x = {x[3], x[2], x[1], x[0]}
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Simplified expression:
    // f = (x2 & ~x0) | (~x3 & x0 & ~x1) | (~x2 & ~x3 & ~x0 & ~x1)
    assign f = (x2 & ~x0) 
             | (~x3 & x0 & ~x1) 
             | (~x2 & ~x3 & ~x0 & ~x1);

endmodule