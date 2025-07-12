module TopModule(
    input [3:0] x,  // x[3] is x[4], x[2] is x[3], x[1] is x[2], x[0] is x[1] in K-map
    output f
);
    assign f = x[3] | (x[2] & x[1] & x[0]);  // x[3] is x[4], x[2] is x[3] in K-map
endmodule