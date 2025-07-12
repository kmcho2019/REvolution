module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);
    
    assign S = P ^ C;
endmodule

module brent_kung_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    // Generate and propagate for each bit
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    
    // First level of prefix computation
    wire [7:0] G1, P1;
    assign {G1[0], P1[0]} = {G[0], P[0]};
    
    genvar i;
    for (i = 1; i < 8; i = i + 1) begin
        assign G1[i] = G[i] | (P[i] & G[i-1]);
        assign P1[i] = P[i] & P[i-1];
    end
    
    // Second level of prefix computation (logarithmic)
    wire [7:0] G2, P2;
    assign {G2[0], P2[0]} = {G1[0], P1[0]};
    assign {G2[1], P2[1]} = {G1[1], P1[1]};
    
    for (i = 2; i < 4; i = i + 1) begin
        assign G2[i] = G1[i] | (P1[i] & G1[i-2]);
        assign P2[i] = P1[i] & P1[i-2];
    end
    
    for (i = 4; i < 8; i = i + 1) begin
        assign G2[i] = G1[i] | (P1[i] & G1[i-4]);
        assign P2[i] = P1[i] & P1[i-4];
    end
    
    // Compute carries
    wire [8:0] C;
    assign C[0] = Cin;
    for (i = 0; i < 8; i = i + 1) begin
        assign C[i+1] = G2[i] | (P2[i] & C[0]);
    end
    
    // Compute sum
    assign S = P ^ C[7:0];
    assign Cout = C[8];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    
    // First level: 8-bit Brent-Kung blocks
    brent_kung_8bit bk0 (.A(A[8:1]), .B(B[8:1]), .Cin(1'b0), .S(S[8:1]), .Cout(carry[0]));
    brent_kung_8bit bk1 (.A(A[16:9]), .B(B[16:9]), .Cin(carry[0]), .S(S[16:9]), .Cout(carry[1]));
    brent_kung_8bit bk2 (.A(A[24:17]), .B(B[24:17]), .Cin(carry[1]), .S(S[24:17]), .Cout(carry[2]));
    brent_kung_8bit bk3 (.A(A[32:25]), .B(B[32:25]), .Cin(carry[2]), .S(S[32:25]), .Cout(carry[3]));
    
    // Second level: Carry lookahead across 8-bit blocks
    wire [3:0] G_block = carry;
    wire [3:0] P_block = {4{1'b1}}; // Always propagate between blocks
    
    wire [3:0] C_block;
    assign C_block[0] = carry[0];
    assign C_block[1] = G_block[0] | (P_block[0] & C_block[0]);
    assign C_block[2] = G_block[1] | (P_block[1] & C_block[1]);
    assign C_block[3] = G_block[2] | (P_block[2] & C_block[2]);
    
    assign C32 = carry[3];
endmodule