module TopModule(
    input  [3:0] x,
    output      f
);
    wire nx0 = ~x[0];
    wire nx1 = ~x[1];
    wire nx2 = ~x[2];
    wire nx3 = ~x[3];

    wire term1 = nx2 & nx3 & nx0 & nx1;       // ~x2 & ~x3 & ~x0 & ~x1
    wire term2 = nx2 & nx3 & x[0] & nx1;      // ~x2 & ~x3 & x0 & ~x1
    wire term3 = x[2] & nx1;                   // x2 & ~x1

    assign f = term1 | term2 | term3;
endmodule