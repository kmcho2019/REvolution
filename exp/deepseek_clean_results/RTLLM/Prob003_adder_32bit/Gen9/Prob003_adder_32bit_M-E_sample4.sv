module pp_cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G_block,
    output P_block
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    // Parallel-prefix carry computation
    wire [1:0] G1, P1;
    assign G1[0] = G[0];
    assign P1[0] = P[0];
    assign G1[1] = G[1] | (P[1] & G[0]);
    assign P1[1] = P[1] & P[0];
    
    wire [3:0] G2, P2;
    assign G2[0] = G1[0];
    assign P2[0] = P1[0];
    assign G2[1] = G1[1];
    assign P2[1] = P1[1];
    assign G2[2] = G[2] | (P[2] & G1[1]);
    assign P2[2] = P[2] & P1[1];
    assign G2[3] = G[3] | (P[3] & (G[2] | (P[2] & G1[1])));
    assign P2[3] = P[3] & P[2] & P1[1];
    
    assign C[0] = Cin;
    assign C[1] = G2[0] | (P2[0] & Cin);
    assign C[2] = G2[1] | (P2[1] & Cin);
    assign C[3] = G2[2] | (P2[2] & Cin);
    
    assign S = P ^ C;
    assign G_block = G2[3];
    assign P_block = P2[3];
endmodule

module pp_cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output G_block,
    output P_block
);
    wire [1:0] G4, P4;
    wire C4;
    
    // First 4-bit block
    pp_cla_4bit cla0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .G_block(G4[0]),
        .P_block(P4[0])
    );
    
    // Second 4-bit block with carry merge
    wire carry_internal = G4[0] | (P4[0] & Cin);
    pp_cla_4bit cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(carry_internal),
        .S(S[7:4]),
        .G_block(G4[1]),
        .P_block(P4[1])
    );
    
    // Block-level generate/propagate
    assign G_block = G4[1] | (P4[1] & G4[0]);
    assign P_block = P4[1] & P4[0];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] G8, P8;
    wire [3:0] carry;
    
    // First 8-bit block
    pp_cla_8bit block0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(1'b0),
        .S(S[8:1]),
        .G_block(G8[0]),
        .P_block(P8[0])
    );
    
    // Subsequent blocks with parallel carry merge
    assign carry[0] = G8[0] | (P8[0] & 1'b0);
    pp_cla_8bit block1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(carry[0]),
        .S(S[16:9]),
        .G_block(G8[1]),
        .P_block(P8[1])
    );
    
    assign carry[1] = G8[1] | (P8[1] & carry[0]);
    pp_cla_8bit block2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(carry[1]),
        .S(S[24:17]),
        .G_block(G8[2]),
        .P_block(P8[2])
    );
    
    assign carry[2] = G8[2] | (P8[2] & carry[1]);
    pp_cla_8bit block3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(carry[2]),
        .S(S[32:25]),
        .G_block(G8[3]),
        .P_block(P8[3])
    );
    
    // Final carry out
    assign C32 = G8[3] | (P8[3] & carry[2]);
endmodule