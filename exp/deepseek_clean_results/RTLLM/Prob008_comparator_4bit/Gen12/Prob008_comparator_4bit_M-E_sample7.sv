module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Generate propagate (P) and generate (G) signals
    wire [3:0] P = ~(A ^ B);  // 1 if bits equal
    wire [3:0] G = A & ~B;    // 1 if A bit > B bit

    // First level prefix computation
    wire [1:0] P1, G1;
    assign P1[0] = P[1] & P[0];
    assign G1[0] = G[1] | (P[1] & G[0]);
    assign P1[1] = P[3] & P[2];
    assign G1[1] = G[3] | (P[3] & G[2]);

    // Second level prefix computation
    wire P_final = P1[1] & P1[0];
    wire G_final = G1[1] | (P1[1] & G1[0]);

    // Output assignments
    assign A_equal = P_final;
    assign A_greater = G_final;
    assign A_less = ~P_final & ~G_final;

endmodule