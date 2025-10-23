module TopModule(
    input  [3:0] x,
    output      f
);
    wire nx0 = ~x[0];
    wire nx1 = ~x[1];
    wire nx2 = ~x[2];
    wire nx3 = ~x[3];

    // term1: ~x2 & ~x3 & ~x1
    wire term1 = nx2 & nx3 & nx1;

    // sub-expression for term23
    wire sub1 = nx0;          // ~x0
    wire sub2 = nx3 & nx1;    // ~x3 & ~x1
    wire term23 = x[2] & (sub1 | sub2);

    // term4: x2 & x3 & x0 & x1
    wire term4 = x[2] & x[3] & x[0] & x[1];

    assign f = term1 | term23 | term4;
endmodule