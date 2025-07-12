module TopModule(
    input  [3:0] x,
    output      f
);
    // Implement f = x[3] OR (~x[3] AND x[2] AND x[1] AND x[0])
    assign f = x[3] | (~x[3] & x[2] & x[1] & x[0]);
endmodule