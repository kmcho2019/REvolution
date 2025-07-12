module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Generate propagate (P) and generate (G) signals for each bit
wire [3:0] P, G;
assign P = ~(A ^ B);  // 1 if bits are equal
assign G = A & ~B;    // 1 if A's bit is greater

// Parallel prefix computation (Brent-Kung tree)
// Stage 1: Bit-level to 2-bit groups
wire [1:0] P1, G1;
assign P1[0] = P[1] & P[0];
assign G1[0] = G[1] | (P[1] & G[0]);
assign P1[1] = P[3] & P[2];
assign G1[1] = G[3] | (P[3] & G[2]);

// Stage 2: 2-bit to 4-bit groups
wire P2, G2;
assign P2 = P1[1] & P1[0];
assign G2 = G1[1] | (P1[1] & G1[0]);

// Final outputs
assign A_equal = P2;
assign A_greater = G2;
assign A_less = ~A_equal & ~A_greater;

endmodule