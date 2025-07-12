module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output      f
);

    wire x4 = x[3];
    wire x3 = x[2];
    wire x2 = x[1];
    wire x1 = x[0];

    assign f = (x3 & ~x2) | (~x4 & x3 & x2 & x1);

endmodule