module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Parallel equality check (fastest path)
    wire equal = (A == B);
    
    // Generate propagate (P) and generate (G) signals for each bit
    wire [3:0] P = A ~^ B;  // XNOR for bit equality
    wire [3:0] G = A & ~B;  // AND for A > B condition
    
    // Carry-lookahead style magnitude comparison
    wire greater = G[3] | 
                  (P[3] & G[2]) | 
                  (P[3] & P[2] & G[1]) | 
                  (P[3] & P[2] & P[1] & G[0]);

    // Output assignments (mutually exclusive by construction)
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule