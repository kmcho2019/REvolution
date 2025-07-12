module TopModule(
    input [3:0] x,  // x[3:4] = rows, x[1:2] = columns
    output f
);
    assign f = (x[3] & ~x[1]) | 
               (~x[3] & x[4] & x[1] & x[2]);
endmodule