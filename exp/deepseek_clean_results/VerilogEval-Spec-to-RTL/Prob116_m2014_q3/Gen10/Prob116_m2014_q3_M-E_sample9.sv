module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // Mux implementation with x[2] as selector
    assign f = x[2] ? (~x[0] | (x[3] & x[1])) : 
                         (x[3] & x[1] & x[0]);
endmodule