module TopModule(
    input [3:0] x,  // x[3:0] maps to x[4:1] in K-map (x[3]=x[4], x[2]=x[3], x[1]=x[2], x[0]=x[1])
    output f
);
    assign f = x[3] | (x[1] & x[2] & ~x[0]);
endmodule