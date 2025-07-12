module TopModule(
    input [3:0] x,
    output f
);

    assign f = (~x[2] & ~x[3] & (~x[0] & ~x[1] | x[0] & ~x[1])) |
               (x[2] & (x[3] | ~x[3]) & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & x[1])) |
               (x[2] & ~x[3] & (~x[0] & ~x[1] | ~x[0] & x[1] | x[0] & ~x[1]));

    // Further simplification by observing that some terms can be directly combined
    // assign f = ((~x[2] & ~x[3]) | x[2]) & ((~x[0] & ~x[1]) | (~x[0] & x[1]) | (x[0] & ~x[1]) | (x[0] & x[1]));
    // However, this simplification might not directly apply due to the specific conditions in the K-map

    // Considering an alternative approach based on K-map observations
    assign f = ((~x[2] & ~x[3] & ~x[0] & ~x[1]) | 
               (~x[2] & ~x[3] & x[0] & ~x[1]) | 
               (x[2] & ~x[3] & ~x[0] & ~x[1]) | 
               (x[2] & ~x[3] & x[0] & ~x[1]) | 
               (x[2] & ~x[3] & ~x[0] & x[1]) | 
               (x[2] & x[3] & ~x[0] & ~x[1]) | 
               (x[2] & x[3] & ~x[0] & x[1]) | 
               (x[2] & x[3] & x[0] & x[1]));

endmodule