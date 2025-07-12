module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Block-level PG signals (8-bit blocks)
    wire [3:0] G_block, P_block;
    wire [3:0] C_block;
    
    // Generate block-level PG signals
    assign G_block[0] = |(A[8:1] & B[8:1]);
    assign P_block[0] = &(A[8:1] ^ B[8:1]);
    
    assign G_block[1] = |(A[16:9] & B[16:9]);
    assign P_block[1] = &(A[16:9] ^ B[16:9]);
    
    assign G_block[2] = |(A[24:17] & B[24:17]);
    assign P_block[2] = &(A[24:17] ^ B[24:17]);
    
    assign G_block[3] = |(A[32:25] & B[32:25]);
    assign P_block[3] = &(A[32:25] ^ B[32:25]);
    
    // Compute block carries using parallel prefix
    assign C_block[0] = 1'b0;  // Initial carry-in
    assign C_block[1] = G_block[0] | (P_block[0] & C_block[0]);
    assign C_block[2] = G_block[1] | (P_block[1] & C_block[1]);
    assign C_block[3] = G_block[2] | (P_block[2] & C_block[2]);
    assign C32 = G_block[3] | (P_block[3] & C_block[3]);
    
    // Generate sum bits using 8-bit CLA slices
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : cla_slice
            wire [7:0] P = A[8*i+8:8*i+1] ^ B[8*i+8:8*i+1];
            wire [7:0] G = A[8*i+8:8*i+1] & B[8*i+8:8*i+1];
            wire [7:0] C;
            
            assign C[0] = C_block[i];
            assign C[1] = G[0] | (P[0] & C[0]);
            assign C[2] = G[1] | (P[1] & C[1]);
            assign C[3] = G[2] | (P[2] & C[2]);
            assign C[4] = G[3] | (P[3] & C[3]);
            assign C[5] = G[4] | (P[4] & C[4]);
            assign C[6] = G[5] | (P[5] & C[5]);
            assign C[7] = G[6] | (P[6] & C[6]);
            
            assign S[8*i+8:8*i+1] = P ^ C;
        end
    endgenerate
endmodule