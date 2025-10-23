module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Propagate and Generate signals
    wire [7:0] P, G;
    // Carry signals
    wire [7:0] C;

    // Compute P and G for each bit
    assign P = a ^ b;
    assign G = a & b;

    // Carry lookahead logic (4-bit blocks)
    assign C[0] = cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    
    // Second level carry lookahead
    wire [3:0] P_block, G_block;
    assign P_block[0] = &P[3:0];
    assign G_block[0] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    
    assign P_block[1] = &P[7:4];
    assign G_block[1] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]);
    
    // Block carry computation
    wire block_carry;
    assign block_carry = G_block[0] | (P_block[0] & C[0]);
    
    // Upper 4-bit carries
    assign C[4] = G[3] | (P[3] & block_carry);
    assign C[5] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & block_carry);
    assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & block_carry);
    assign C[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | 
                 (P[6] & P[5] & P[4] & P[3] & block_carry);

    // Sum computation
    assign sum = P ^ C;
    assign cout = G[7] | (P[7] & C[7]);

endmodule