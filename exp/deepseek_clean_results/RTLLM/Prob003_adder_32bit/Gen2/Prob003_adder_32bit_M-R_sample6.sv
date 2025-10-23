module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // 8-bit block P and G signals
    wire [3:0] P_block, G_block;
    wire [3:0] block_carry;
    
    // Compute P and G for each 8-bit block
    assign P_block[0] = ^(A[8:1]  ^ B[8:1]);
    assign G_block[0] = (A[8:1]  & B[8:1]) == 8'hFF ? 1'b1 :
                       ((A[7:1] & B[7:1]) == 7'h7F ? (A[8] | B[8]) :
                       // ... similar logic for other bit positions
                       1'b0;
    
    assign P_block[1] = ^(A[16:9] ^ B[16:9]);
    assign G_block[1] = (A[16:9] & B[16:9]) == 8'hFF ? 1'b1 :
                       ((A[15:9] & B[15:9]) == 7'h7F ? (A[16] | B[16]) :
                       1'b0;
    
    assign P_block[2] = ^(A[24:17] ^ B[24:17]);
    assign G_block[2] = (A[24:17] & B[24:17]) == 8'hFF ? 1'b1 :
                       ((A[23:17] & B[23:17]) == 7'h7F ? (A[24] | B[24]) :
                       1'b0;
    
    assign P_block[3] = ^(A[32:25] ^ B[32:25]);
    assign G_block[3] = (A[32:25] & B[32:25]) == 8'hFF ? 1'b1 :
                       ((A[31:25] & B[31:25]) == 7'h7F ? (A[32] | B[32]) :
                       1'b0;
    
    // Block carry lookahead logic
    assign block_carry[0] = 1'b0;  // Cin
    assign block_carry[1] = G_block[0] | (P_block[0] & block_carry[0]);
    assign block_carry[2] = G_block[1] | (P_block[1] & block_carry[1]);
    assign block_carry[3] = G_block[2] | (P_block[2] & block_carry[2]);
    assign C32           = G_block[3] | (P_block[3] & block_carry[3]);
    
    // Instantiate 8-bit CLAs with computed carries
    cla_8bit block0 (.A(A[8:1]),   .B(B[8:1]),   .Cin(block_carry[0]), .S(S[8:1]));
    cla_8bit block1 (.A(A[16:9]),  .B(B[16:9]),  .Cin(block_carry[1]), .S(S[16:9]));
    cla_8bit block2 (.A(A[24:17]), .B(B[24:17]), .Cin(block_carry[2]), .S(S[24:17]));
    cla_8bit block3 (.A(A[32:25]), .B(B[32:25]), .Cin(block_carry[3]), .S(S[32:25]));
endmodule

module cla_8bit (
    input [8:1] A,
    input [8:1] B,
    input Cin,
    output [8:1] S
);
    wire [8:1] P = A ^ B;
    wire [8:1] G = A & B;
    wire [8:1] C;
    
    assign C[1] = Cin;
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]);
    
    assign S = P ^ C;
endmodule