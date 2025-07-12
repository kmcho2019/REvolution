module TopModule(
    input [3:0] x,  // x[3:0] maps to x[4:1] in K-map
    output f
);
    assign f = x[3] | (x[2] & x[1] & x[0]);
endmodule