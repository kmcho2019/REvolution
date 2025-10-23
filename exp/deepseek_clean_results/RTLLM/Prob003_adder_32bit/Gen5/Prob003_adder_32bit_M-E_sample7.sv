module CLA_8bit_ks(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Pg,
    output Gg
);
    wire [7:0] P, G;
    wire [8:1] C;
    
    // Generate and propagate signals
    assign P = A ^ B;
    assign G = A & B;
    
    // Kogge-Stone parallel prefix carry computation
    // First level
    wire [7:0] G1, P1;
    assign G1[0] = G[0];
    assign P1[0] = P[0];
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : ks_first_level
            assign G1[i] = G[i] | (P[i] & G[i-1]);
            assign P1[i] = P[i] & P[i-1];
        end
    endgenerate
    
    // Second level (skip by 2)
    wire [7:0] G2, P2;
    assign G2[1:0] = G1[1:0];
    assign P2[1:0] = P1[1:0];
    generate
        for (i = 2; i < 8; i = i + 1) begin : ks_second_level
            assign G2[i] = G1[i] | (P1[i] & G1[i-2]);
            assign P2[i] = P1[i] & P1[i-2];
        end
    endgenerate
    
    // Third level (skip by 4)
    wire [7:0] G3, P3;
    assign G3[3:0] = G2[3:0];
    assign P3[3:0] = P2[3:0];
    generate
        for (i = 4; i < 8; i = i + 1) begin : ks_third_level
            assign G3[i] = G2[i] | (P2[i] & G2[i-4]);
            assign P3[i] = P2[i] & P2[i-4];
        end
    endgenerate
    
    // Final carry computation
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G1[1] | (P1[1] & Cin);
    assign C[3] = G1[2] | (P1[2] & Cin);
    assign C[4] = G2[3] | (P2[3] & Cin);
    assign C[5] = G2[4] | (P2[4] & Cin);
    assign C[6] = G2[5] | (P2[5] & Cin);
    assign C[7] = G2[6] | (P2[6] & Cin);
    assign C[8] = G3[7] | (P3[7] & Cin);
    
    // Sum and group signals
    assign S = P ^ {C[7:1], Cin};
    assign Pg = &P;
    assign Gg = G3[7];
endmodule

module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] P, G;
    wire [4:0] C;
    
    assign C[0] = 1'b0;
    
    // Instantiate 8-bit CLA blocks with Kogge-Stone carry
    CLA_8bit_ks cla0(.A(A[8:1]), .B(B[8:1]), .Cin(C[0]), .S(S[8:1]), .Pg(P[0]), .Gg(G[0]));
    CLA_8bit_ks cla1(.A(A[16:9]), .B(B[16:9]), .Cin(C[1]), .S(S[16:9]), .Pg(P[1]), .Gg(G[1]));
    CLA_8bit_ks cla2(.A(A[24:17]), .B(B[24:17]), .Cin(C[2]), .S(S[24:17]), .Pg(P[2]), .Gg(G[2]));
    CLA_8bit_ks cla3(.A(A[32:25]), .B(B[32:25]), .Cin(C[3]), .S(S[32:25]), .Pg(P[3]), .Gg(G[3]));
    
    // Hierarchical carry lookahead with Brent-Kung structure
    wire [1:0] P1, G1;
    wire [3:0] P2, G2;
    
    // First level
    assign P1[0] = P[0] & P[1];
    assign G1[0] = G[1] | (P[1] & G[0]);
    assign P1[1] = P[2] & P[3];
    assign G1[1] = G[3] | (P[3] & G[2]);
    
    // Second level
    assign P2[0] = P1[0] & P1[1];
    assign G2[0] = G1[1] | (P1[1] & G1[0]);
    
    // Carry generation
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G1[0] | (P1[0] & C[0]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G2[0] | (P2[0] & C[0]);
    
    assign C32 = C[4];
endmodule