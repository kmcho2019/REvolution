module pg_unit(
    input A,
    input B,
    output P,
    output G
);
    assign P = A ^ B;
    assign G = A & B;
endmodule

module cla_4bit_pp (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] P, G;
    wire [3:0] C;
    
    // Generate PG signals
    pg_unit pg0(A[0], B[0], P[0], G[0]);
    pg_unit pg1(A[1], B[1], P[1], G[1]);
    pg_unit pg2(A[2], B[2], P[2], G[2]);
    pg_unit pg3(A[3], B[3], P[3], G[3]);
    
    // Parallel prefix carry computation
    wire [3:0] GG, PP;
    assign GG[0] = G[0];
    assign PP[0] = P[0];
    
    assign GG[1] = G[1] | (P[1] & G[0]);
    assign PP[1] = P[1] & P[0];
    
    assign GG[2] = G[2] | (P[2] & GG[1]);
    assign PP[2] = P[2] & PP[1];
    
    assign GG[3] = G[3] | (P[3] & GG[2]);
    assign PP[3] = P[3] & PP[2];
    
    // Final carries
    assign C[0] = Cin;
    assign C[1] = GG[0] | (PP[0] & Cin);
    assign C[2] = GG[1] | (PP[1] & Cin);
    assign C[3] = GG[2] | (PP[2] & Cin);
    assign Cout = GG[3] | (PP[3] & Cin);
    
    // Sum computation
    assign S = P ^ C;
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [1:0] carry;
    wire [1:0] GG, PP;
    
    // First 4-bit block
    cla_4bit_pp cla0 (
        .A(A[3:0]), 
        .B(B[3:0]), 
        .Cin(Cin), 
        .S(S[3:0]), 
        .Cout()
    );
    
    // Compute block PG signals
    assign GG[0] = (A[3:0] & B[3:0]) != 0;
    assign PP[0] = (A[3:0] ^ B[3:0]) == 4'hF;
    
    // Second 4-bit block with lookahead
    wire [3:0] P1, G1;
    pg_unit pg4(A[4], B[4], P1[0], G1[0]);
    pg_unit pg5(A[5], B[5], P1[1], G1[1]);
    pg_unit pg6(A[6], B[6], P1[2], G1[2]);
    pg_unit pg7(A[7], B[7], P1[3], G1[3]);
    
    // Parallel prefix for upper 4 bits
    wire [3:0] GG1, PP1;
    assign GG1[0] = G1[0];
    assign PP1[0] = P1[0];
    
    assign GG1[1] = G1[1] | (P1[1] & G1[0]);
    assign PP1[1] = P1[1] & P1[0];
    
    assign GG1[2] = G1[2] | (P1[2] & GG1[1]);
    assign PP1[2] = P1[2] & PP1[1];
    
    assign GG1[3] = G1[3] | (P1[3] & GG1[2]);
    assign PP1[3] = P1[3] & PP1[2];
    
    // Combined block PG
    assign GG[1] = GG1[3] | (PP1[3] & GG[0]);
    assign PP[1] = PP1[3] & PP[0];
    
    // Generate carries
    assign carry[0] = GG[0] | (PP[0] & Cin);
    assign carry[1] = GG[1] | (PP[1] & Cin);
    
    // Upper 4-bit sum
    assign S[7:4] = P1 ^ {carry[0], GG1[0] | (PP1[0] & carry[0]),
                          GG1[1] | (PP1[1] & carry[0]),
                          GG1[2] | (PP1[2] & carry[0])};
    
    assign Cout = carry[1];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    wire [3:0] GG, PP;
    
    // First 8-bit block
    cla_8bit block0 (
        .A(A[8:1]), 
        .B(B[8:1]), 
        .Cin(1'b0), 
        .S(S[8:1]), 
        .Cout(carry[0])
    );
    
    // Compute block PG for first 8 bits
    assign GG[0] = (A[8:1] & B[8:1]) != 0;
    assign PP[0] = (A[8:1] ^ B[8:1]) == 8'hFF;
    
    // Remaining blocks with two-level lookahead
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : blocks
            // Block PG computation
            wire block_GG = (A[i*8+8:i*8+1] & B[i*8+8:i*8+1]) != 0;
            wire block_PP = (A[i*8+8:i*8+1] ^ B[i*8+8:i*8+1]) == 8'hFF;
            
            // Two-level lookahead
            assign GG[i] = block_GG | (block_PP & GG[i-1]);
            assign PP[i] = block_PP & PP[i-1];
            
            // Carry generation
            assign carry[i] = GG[i-1] | (PP[i-1] & carry[i-1]);
            
            // Block instantiation
            cla_8bit block (
                .A(A[i*8+8:i*8+1]), 
                .B(B[i*8+8:i*8+1]), 
                .Cin(carry[i-1]), 
                .S(S[i*8+8:i*8+1]), 
                .Cout()
            );
        end
    endgenerate
    
    assign C32 = carry[3];
endmodule