module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in the K-map
    output f
);
    // Priority-based implementation
    assign f = x[3] ? 
               (~x[2] | (x[0] & x[1])) :  // When x[3] is 1
               (x[2] ? 
                (x[0] | ~x[1]) :         // When x[3]=0 and x[2]=1
                0);                       // When x[3]=0 and x[2]=0
endmodule