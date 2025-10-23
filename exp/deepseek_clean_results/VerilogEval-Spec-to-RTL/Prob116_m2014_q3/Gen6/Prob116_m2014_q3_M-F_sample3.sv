module TopModule(
    input [3:0] x,  // x[3], x[2], x[1], x[0] (x[0] is x[4] in K-map)
    output f
);
    assign f = (x[3] & ~(x[0] & ~x[1] & x[2])) | 
               (~x[3] & x[0] & x[1] & x[2]);
endmodule