module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Generate (G) and Propagate (P) signals
    wire [7:0] G = a & b;
    wire [7:0] P = a ^ b;

    // Carry computation (4-bit lookahead)
    wire [1:0] C;
    assign C[0] = cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
                 (P[3] & P[2] & P[1] & P[0] & C[0]);

    // Second level carry computation
    wire [1:0] GG, PG;
    assign GG[0] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign PG[0] = P[3] & P[2] & P[1] & P[0];
    assign GG[1] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]);
    assign PG[1] = P[7] & P[6] & P[5] & P[4];

    wire C8 = GG[1] | (PG[1] & GG[0]) | (PG[1] & PG[0] & C[0]);

    // Final carry assignment
    wire [8:0] carry = {C8, 
                        GG[0] | (PG[0] & C[0]),
                        C[4], C[3], C[2], C[1], C[0]};

    // Sum computation
    assign sum = P ^ carry[7:0];
    assign cout = carry[8];

endmodule