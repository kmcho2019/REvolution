module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise comparison signals
    wire [3:0] P = A ~^ B;  // Bit equality
    wire [3:0] G = A & ~B;  // Bit greater

    // Parallel prefix combination
    wire [1:0] P10 = P[1] & P[0];
    wire [1:0] G10 = G[1] | (G[0] & P[1]);
    
    wire [3:0] P32 = P[3] & P[2];
    wire [3:0] G32 = G[3] | (G[2] & P[3]);
    
    wire P_full = P32 & P10;
    wire G_full = G32 | (G10 & P32);

    // Output assignments
    assign A_equal = &P;  // All bits equal
    assign A_greater = G_full;
    assign A_less = ~A_equal & ~A_greater;  // Mutually exclusive

endmodule