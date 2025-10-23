module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Carry Generate and Propagate signals
    wire [7:0] G, P;
    wire [7:0] C;
    
    // Generate and Propagate signals
    assign G = a & b;  // Generate
    assign P = a ^ b;  // Propagate
    
    // Carry computation - 2-level lookahead
    assign C[0] = cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    
    // Second level carry computation
    wire [1:0] G_block, P_block;
    assign G_block[0] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign P_block[0] = P[3] & P[2] & P[1] & P[0];
    
    assign C[4] = G_block[0] | (P_block[0] & C[0]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & C[4]);
    assign C[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & C[4]);
    
    assign G_block[1] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]);
    assign P_block[1] = P[7] & P[6] & P[5] & P[4];
    
    assign cout = G_block[1] | (P_block[1] & C[4]);
    
    // Sum computation
    assign sum = P ^ C[7:0];
    
endmodule