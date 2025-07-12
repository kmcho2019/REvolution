module TopModule(
    input  [3:0] x,  // x = {x3,x2,x1,x0}
    output       f
);
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    wire not_x0 = ~x0;
    wire not_x1 = ~x1;
    wire not_x2 = ~x2;
    wire not_x3 = ~x3;

    wire not_x0_and_not_x1 = not_x0 | not_x1; // ~x0 + ~x1
    wire term1 = x2 & not_x0_and_not_x1;     // x2 & (~x0 + ~x1)
    wire term2 = not_x2 & not_x3 & not_x1;   // ~x2 & ~x3 & ~x1

    assign f = term1 | term2;
endmodule