module TopModule(
    input  [3:0] x,
    output      f
);
    wire nx0 = ~x[0];
    wire nx1 = ~x[1];
    wire nx3 = ~x[3];
    wire nx2 = ~x[2];
    
    wire term1 = nx2 & nx3 & nx1;                 // ~x2 & ~x3 & ~x1
    wire term23_inner = nx0 | (nx3 & nx1);        // ~x0 | (~x3 & ~x1)
    wire term23 = x[2] & term23_inner;            // x2 & (...)
    wire term4 = x[2] & x[3] & x[0] & x[1];       // x2 & x3 & x0 & x1
    
    assign f = term1 | term23 | term4;
endmodule