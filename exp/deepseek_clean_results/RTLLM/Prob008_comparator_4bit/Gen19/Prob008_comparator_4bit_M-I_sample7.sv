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
    
    // Shared intermediate terms for magnitude comparison
    wire P3P2 = P[3] & P[2];
    wire P3P2P1 = P3P2 & P[1];
    
    // Optimized hierarchical greater detection
    wire greater = G[3] | 
                  (P[3] & G[2]) | 
                  (P3P2 & G[1]) | 
                  (P3P2P1 & G[0]);
    
    // Direct less-than calculation using same terms
    wire [3:0] L = ~A & B;
    wire less = L[3] | 
               (P[3] & L[2]) | 
               (P3P2 & L[1]) | 
               (P3P2P1 & L[0]);
    
    // Output assignments with natural mutual exclusivity
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & less;

endmodule