module TopModule(
    input [3:0] x,  // x[3:0] maps to [x3,x2,x1,x0] in K-map
    output f
);
    assign f = x[3] | (x[1] & x[2] & ~x[0]);
endmodule