module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise conditions
    wire [3:0] P = ~(A ^ B);  // Bit equality
    wire [3:0] G = A & ~B;    // Bit greater

    // Parallel prefix combination
    wire [3:0] prefix_G;
    wire [3:0] prefix_P;
    
    assign prefix_G[0] = G[0];
    assign prefix_P[0] = P[0];
    
    assign prefix_G[1] = G[1] | (P[1] & prefix_G[0]);
    assign prefix_P[1] = P[1] & prefix_P[0];
    
    assign prefix_G[2] = G[2] | (P[2] & prefix_G[1]);
    assign prefix_P[2] = P[2] & prefix_P[1];
    
    assign prefix_G[3] = G[3] | (P[3] & prefix_G[2]);
    assign prefix_P[3] = P[3] & prefix_P[2];

    // Final outputs
    assign A_greater = prefix_G[3];
    assign A_equal = prefix_P[3];
    assign A_less = ~A_equal & ~A_greater;

endmodule