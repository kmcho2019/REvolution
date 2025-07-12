module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout,
    output G_group,
    output P_group
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    // Group PG logic
    assign G_group = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign P_group = P[3] & P[2] & P[1] & P[0];
    
    // Carry lookahead
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);
    
    // Sum calculation with optimized XOR
    assign S = P ^ {C[2:0], Cin};
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [1:0] G_block, P_block;
    wire carry_mid;
    
    // First 4-bit block with group PG outputs
    cla_4bit cla0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .G_group(G_block[0]),
        .P_group(P_block[0]),
        .Cout()  // Not used - we use block-level lookahead
    );
    
    // Second 4-bit block with group PG outputs
    cla_4bit cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(carry_mid),
        .S(S[7:4]),
        .G_group(G_block[1]),
        .P_group(P_block[1]),
        .Cout()  // Not used - we use block-level lookahead
    );
    
    // Block-level carry lookahead
    assign carry_mid = G_block[0] | (P_block[0] & Cin);
    assign Cout = G_block[1] | (P_block[1] & carry_mid);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] G_block, P_block;
    wire [3:0] carry;
    
    // Generate carry signals for all blocks in parallel
    assign carry[0] = 1'b0;  // Cin for first block
    assign carry[1] = G_block[0] | (P_block[0] & carry[0]);
    assign carry[2] = G_block[1] | (P_block[1] & carry[1]);
    assign carry[3] = G_block[2] | (P_block[2] & carry[2]);
    assign C32 = G_block[3] | (P_block[3] & carry[3]);
    
    // Instantiate 4x 8-bit CLAs with parallel carry computation
    cla_8bit block0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(carry[0]),
        .S(S[8:1]),
        .G_group(G_block[0]),
        .P_group(P_block[0])
    );
    
    cla_8bit block1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(carry[1]),
        .S(S[16:9]),
        .G_group(G_block[1]),
        .P_group(P_block[1])
    );
    
    cla_8bit block2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(carry[2]),
        .S(S[24:17]),
        .G_group(G_block[2]),
        .P_group(P_block[2])
    );
    
    cla_8bit block3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(carry[3]),
        .S(S[32:25]),
        .G_group(G_block[3]),
        .P_group(P_block[3])
    );
endmodule