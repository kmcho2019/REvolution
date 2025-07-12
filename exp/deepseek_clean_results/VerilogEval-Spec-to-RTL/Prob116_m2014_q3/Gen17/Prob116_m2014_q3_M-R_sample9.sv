module TopModule(
    input [3:0] x,  // x[3:0] maps to [x4,x3,x2,x1] in K-map
    output f
);
    assign f = (~x[3] & ~x[4] & x[2]) |  // First term from K-map
               (x[3] & x[1]) |           // Second term from K-map
               (x[4] & x[1]);            // Third term from K-map
endmodule