module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Generate and propagate terms for each bit
    wire [32:0] G = {1'b0, A & B};
    wire [32:0] P = {1'b0, A ^ B};
    
    // Carry calculation (lookahead)
    wire [32:0] C;
    assign C[0] = 1'b0;  // Initial carry-in
    
    // Carry lookahead for 32 bits (8 blocks of 4 bits)
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]);
    
    assign C[9] = G[8] | (P[8] & C[8]);
    assign C[10] = G[9] | (P[9] & C[9]);
    assign C[11] = G[10] | (P[10] & C[10]);
    assign C[12] = G[11] | (P[11] & C[11]);
    
    assign C[13] = G[12] | (P[12] & C[12]);
    assign C[14] = G[13] | (P[13] & C[13]);
    assign C[15] = G[14] | (P[14] & C[14]);
    assign C[16] = G[15] | (P[15] & C[15]);
    
    assign C[17] = G[16] | (P[16] & C[16]);
    assign C[18] = G[17] | (P[17] & C[17]);
    assign C[19] = G[18] | (P[18] & C[18]);
    assign C[20] = G[19] | (P[19] & C[19]);
    
    assign C[21] = G[20] | (P[20] & C[20]);
    assign C[22] = G[21] | (P[21] & C[21]);
    assign C[23] = G[22] | (P[22] & C[22]);
    assign C[24] = G[23] | (P[23] & C[23]);
    
    assign C[25] = G[24] | (P[24] & C[24]);
    assign C[26] = G[25] | (P[25] & C[25]);
    assign C[27] = G[26] | (P[26] & C[26]);
    assign C[28] = G[27] | (P[27] & C[27]);
    
    assign C[29] = G[28] | (P[28] & C[28]);
    assign C[30] = G[29] | (P[29] & C[29]);
    assign C[31] = G[30] | (P[30] & C[30]);
    assign C[32] = G[31] | (P[31] & C[31]);
    
    // Sum calculation
    assign S = P[32:1] ^ C[31:0];
    assign C32 = C[32];
endmodule