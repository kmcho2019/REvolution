module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // Direct implementation combining both terms in one assign
    assign f = (~x[0] & x[2]) | (x[0] & x[1] & x[3]);
endmodule