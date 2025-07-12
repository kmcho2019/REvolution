module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in the K-map
    output f
);
    assign f = x[2] ? x[3] : (x[3] & x[1] & x[0]);
endmodule