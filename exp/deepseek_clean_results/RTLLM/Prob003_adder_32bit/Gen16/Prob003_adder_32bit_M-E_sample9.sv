module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout,
    output Pg,
    output Gg
);
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    wire [7:0] C;
    
    // Carry computation with bypass optimization
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    
    // Group propagate and generate
    assign Pg = &P;
    assign Gg = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | 
               (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) |
               (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) |
               (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) |
               (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]);
    
    assign Cout = Gg | (Pg & Cin);
    assign S = P ^ C;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] block_Pg, block_Gg;
    wire [3:0] block_Cout;
    wire [3:0] carry_in;
    
    // First level carry computation
    assign carry_in[0] = 1'b0;
    assign carry_in[1] = block_Gg[0] | (block_Pg[0] & carry_in[0]);
    assign carry_in[2] = block_Gg[1] | (block_Pg[1] & carry_in[1]);
    assign carry_in[3] = block_Gg[2] | (block_Pg[2] & carry_in[2]);
    
    // 8-bit CLA blocks
    cla_8bit block0 (
        .A(A[8:1]), 
        .B(B[8:1]), 
        .Cin(carry_in[0]), 
        .S(S[8:1]), 
        .Cout(block_Cout[0]),
        .Pg(block_Pg[0]),
        .Gg(block_Gg[0])
    );
    
    cla_8bit block1 (
        .A(A[16:9]), 
        .B(B[16:9]), 
        .Cin(carry_in[1]), 
        .S(S[16:9]), 
        .Cout(block_Cout[1]),
        .Pg(block_Pg[1]),
        .Gg(block_Gg[1])
    );
    
    cla_8bit block2 (
        .A(A[24:17]), 
        .B(B[24:17]), 
        .Cin(carry_in[2]), 
        .S(S[24:17]), 
        .Cout(block_Cout[2]),
        .Pg(block_Pg[2]),
        .Gg(block_Gg[2])
    );
    
    cla_8bit block3 (
        .A(A[32:25]), 
        .B(B[32:25]), 
        .Cin(carry_in[3]), 
        .S(S[32:25]), 
        .Cout(block_Cout[3]),
        .Pg(block_Pg[3]),
        .Gg(block_Gg[3])
    );
    
    // Final carry out
    assign C32 = block_Gg[3] | (block_Pg[3] & carry_in[3]);
endmodule