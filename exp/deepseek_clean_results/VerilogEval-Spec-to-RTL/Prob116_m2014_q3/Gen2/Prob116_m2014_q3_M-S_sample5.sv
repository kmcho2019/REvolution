module TopModule(
    input [3:0] x,
    output f
);
    assign f = x[3] ? 
               ~(x[2] & ~x[1] & x[0]) :  // When x[3]=1
               ((~x[2] & ~x[1] & x[0]) | (x[2] & x[1] & x[0]));  // When x[3]=0
endmodule