module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G_group,
    output P_group
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    
    assign G_group = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign P_group = P[3] & P[2] & P[1] & P[0];
    
    assign S = P ^ C;
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output G_super,
    output P_super
);
    wire [1:0] G, P;
    wire carry_mid;
    
    // Lower 4-bit block
    cla_4bit cla0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .G_group(G[0]),
        .P_group(P[0])
    );
    
    // Upper 4-bit block
    cla_4bit cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(carry_mid),
        .S(S[7:4]),
        .G_group(G[1]),
        .P_group(P[1])
    );
    
    // Super group carry lookahead
    assign carry_mid = G[0] | (P[0] & Cin);
    assign G_super = G[1] | (P[1] & G[0]);
    assign P_super = P[1] & P[0];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] G, P;
    wire [3:0] carry;
    
    // First 8-bit block (bits 1-8)
    cla_8bit block0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(1'b0),
        .S(S[8:1]),
        .G_super(G[0]),
        .P_super(P[0])
    );
    
    // Second 8-bit block (bits 9-16)
    cla_8bit block1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(carry[0]),
        .S(S[16:9]),
        .G_super(G[1]),
        .P_super(P[1])
    );
    
    // Third 8-bit block (bits 17-24)
    cla_8bit block2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(carry[1]),
        .S(S[24:17]),
        .G_super(G[2]),
        .P_super(P[2])
    );
    
    // Fourth 8-bit block (bits 25-32)
    cla_8bit block3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(carry[2]),
        .S(S[32:25]),
        .G_super(G[3]),
        .P_super(P[3])
    );
    
    // 32-bit carry lookahead unit
    assign carry[0] = G[0] | (P[0] & 1'b0);
    assign carry[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & 1'b0);
    assign carry[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & 1'b0);
    assign C32 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule