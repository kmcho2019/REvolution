module TopModule(
    input  [3:0] x, // x = {x4, x3, x2, x1} = {x[3], x[2], x[1], x[0]}
    output       f
);

    wire x4 = x[3];
    wire x3 = x[2];
    wire x2 = x[1];
    wire x1 = x[0];

    wire term1 = x4 & x3 & ~x1;           // Group1: x4=1,x3=1,x1=0
    wire term2 = x4 & ~x3 & ~x1;          // Group2: x4=1,x3=0,x1=0
    wire term3 = ~x4 & x3 & x1 & x2;      // Group3: x4=0,x3=1,x1=1,x2=1

    assign f = term1 | term2 | term3;

endmodule