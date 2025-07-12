module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // Priority-encoded decision tree
    assign f = x[3] ? 
               // When x[3]=1, output 1 unless specific cases
               ~(x[1] & ~x[2] & x[0]) : 
               // When x[3]=0, evaluate carefully
               ((x[1] ^ x[2]) & x[0]) | (~x[1] & x[2]);
endmodule