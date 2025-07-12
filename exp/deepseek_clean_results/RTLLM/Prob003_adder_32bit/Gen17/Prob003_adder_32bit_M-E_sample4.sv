module pp_cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G_block,
    output P_block
);
    // Generate and propagate terms
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    // Parallel-prefix carry computation
    wire C0 = Cin;
    wire C1 = G[0] | (P[0] & C0);
    wire C2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C0);
    wire C3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C0);
    
    // Sum and block outputs
    assign S = P ^ {C3, C2, C1, C0};
    assign G_block = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign P_block = P[3] & P[2] & P[1] & P[0];
endmodule

module pp_cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output G_block,
    output P_block
);
    // First level: 4-bit CLAs with generate/propagate
    wire G0, P0, G1, P1;
    wire carry_mid;
    
    pp_cla_4bit cla0 (
        .A(A[3:0]), .B(B[3:0]), .Cin(Cin),
        .S(S[3:0]), .G_block(G0), .P_block(P0)
    );
    
    // Second level carry lookahead
    wire C4 = G0 | (P0 & Cin);
    
    pp_cla_4bit cla1 (
        .A(A[7:4]), .B(B[7:4]), .Cin(C4),
        .S(S[7:4]), .G_block(G1), .P_block(P1)
    );
    
    // Block generate/propagate
    assign G_block = G1 | (P1 & G0);
    assign P_block = P1 & P0;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Block generate/propagate terms
    wire [3:0] G, P;
    wire [3:0] carry;
    
    // First level: 8-bit blocks
    pp_cla_8bit block0 (
        .A(A[8:1]), .B(B[8:1]), .Cin(1'b0),
        .S(S[8:1]), .G_block(G[0]), .P_block(P[0])
    );
    
    // Second level carry lookahead
    wire C8 = G[0] | (P[0] & 1'b0);
    
    pp_cla_8bit block1 (
        .A(A[16:9]), .B(B[16:9]), .Cin(C8),
        .S(S[16:9]), .G_block(G[1]), .P_block(P[1])
    );
    
    // Third level carry lookahead
    wire C16 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & 1'b0);
    
    // Mixed 8-bit + 4-bit blocks for better balance
    pp_cla_8bit block2 (
        .A(A[24:17]), .B(B[24:17]), .Cin(C16),
        .S(S[24:17]), .G_block(G[2]), .P_block(P[2])
    );
    
    // Final level carry lookahead
    wire C24 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]);
    
    // Final 8-bit block
    pp_cla_8bit block3 (
        .A(A[32:25]), .B(B[32:25]), .Cin(C24),
        .S(S[32:25]), .G_block(G[3]), .P_block(P[3])
    );
    
    // Final carry out
    assign C32 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule