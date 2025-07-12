/**
 * 8-bit Carry Lookahead Adder - Optimized Implementation
 * Uses hierarchical carry lookahead to break critical path
 * 4-bit blocks with lookahead carry generation
 * Brent-Kung parallel prefix structure for carry computation
 */
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Generate Propagate (P) and Generate (G) terms for each bit
    wire [7:0] P, G;
    assign P = a ^ b;          // Propagate terms
    assign G = a & b;          // Generate terms

    // Carry Lookahead Logic - Brent-Kung structure
    // First level carry computation (bit pairs)
    wire [3:0] P1, G1;
    assign P1[0] = P[0] & P[1];
    assign G1[0] = G[1] | (P[1] & G[0]);
    assign P1[1] = P[2] & P[3];
    assign G1[1] = G[3] | (P[3] & G[2]);
    assign P1[2] = P[4] & P[5];
    assign G1[2] = G[5] | (P[5] & G[4]);
    assign P1[3] = P[6] & P[7];
    assign G1[3] = G[7] | (P[7] & G[6]);

    // Second level carry computation (4-bit groups)
    wire [1:0] P2, G2;
    assign P2[0] = P1[0] & P1[1];
    assign G2[0] = G1[1] | (P1[1] & G1[0]);
    assign P2[1] = P1[2] & P1[3];
    assign G2[1] = G1[3] | (P1[3] & G1[2]);

    // Third level carry computation (full 8-bit)
    wire P3, G3;
    assign P3 = P2[0] & P2[1];
    assign G3 = G2[1] | (P2[1] & G2[0]);

    // Carry generation for each bit
    wire [7:0] C;
    assign C[0] = cin;
    assign C[1] = G[0] | (P[0] & cin);
    assign C[2] = G1[0] | (P1[0] & cin);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G2[0] | (P2[0] & cin);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G1[2] | (P1[2] & C[4]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign cout = G3 | (P3 & cin);

    // Sum computation
    assign sum = P ^ C;

endmodule