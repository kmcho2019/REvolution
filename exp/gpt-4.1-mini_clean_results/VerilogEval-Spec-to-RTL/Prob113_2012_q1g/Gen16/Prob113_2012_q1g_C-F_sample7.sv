module TopModule(
    input  [3:0] x,
    output       f
);

    wire nx3 = ~x[3];
    wire nx1 = ~x[1];
    wire nx0 = ~x[0];

    assign f = (nx3 & (nx1 | (x[2] & x[1] & nx0))) 
             | (x[3] & x[2] & (nx0 | x[1]));

endmodule