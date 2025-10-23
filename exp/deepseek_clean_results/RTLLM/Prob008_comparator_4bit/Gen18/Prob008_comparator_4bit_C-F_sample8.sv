module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Shared propagate signals (bit equality)
    wire [3:0] P = ~(A ^ B);
    
    // Parallel equality check (fastest path)
    wire equal = &P;
    
    // Generate signals (A > B at each bit)
    wire [3:0] G = A & ~B;
    
    // Optimized hierarchical greater detection
    wire greater = G[3] |
                 (P[3] & G[2]) |
                 (&P[3:2] & G[1]) |
                 (&P[3:1] & G[0]);
    
    // Output assignments with natural mutual exclusivity
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule