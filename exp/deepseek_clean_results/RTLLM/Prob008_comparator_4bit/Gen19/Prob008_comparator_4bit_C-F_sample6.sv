module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise equality signals (propagate)
    wire [3:0] P = ~(A ^ B);
    
    // Parallel equality check (fastest path)
    wire equal = &P;
    
    // Bit-wise greater signals (generate)
    wire [3:0] G = A & ~B;
    
    // Optimized hierarchical greater detection with early termination
    wire greater = G[3] |                     // MSB decides
                  (P[3] & G[2]) |            // If MSBs equal, check next
                  (P[3] & P[2] & G[1]) |     // If upper 2 equal, check next
                  (P[3] & P[2] & P[1] & G[0]); // If upper 3 equal, check LSB
    
    // Output assignments with natural mutual exclusivity
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule