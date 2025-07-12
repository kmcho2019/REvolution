module TopModule(
    input [3:0] x,
    output f
);
    wire x4 = x[3]; // x[4] in K-map
    wire x3 = x[2]; // x[3] in K-map
    wire x2 = x[1]; // x[2] in K-map
    wire x1 = x[0]; // x[1] in K-map

    assign f = x4 | (x3 & x2) | (x1 & ~x4 & ~x3);
endmodule