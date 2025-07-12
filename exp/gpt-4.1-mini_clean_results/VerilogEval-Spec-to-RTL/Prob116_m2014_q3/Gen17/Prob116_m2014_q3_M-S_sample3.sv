module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    // Direct implementation of minimized sum-of-products expression
    assign f = (x[3] & ~x[1]) 
             | (x[3] & x[2] & x[1] & ~x[0]) 
             | (~x[3] & x[2] & x[1] & x[0]);

endmodule