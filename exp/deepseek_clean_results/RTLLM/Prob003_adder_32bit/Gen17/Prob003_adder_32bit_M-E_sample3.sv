module manchester_carry_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout,
    output G_group,
    output P_group
);
    // Generate and propagate terms
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    
    // Compound carry computation
    wire C1 = G[0] | (P[0] & Cin);
    wire C2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    wire C3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    wire C4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
              (P[3] & P[2] & P[1] & P[0] & Cin);
    wire C5 = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | 
              (P[4] & P[3] & P[2] & P[1] & G[0]) | (P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    wire C6 = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | 
              (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | 
              (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    wire C7 = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | 
              (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | 
              (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | 
              (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    wire C8 = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | 
              (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | 
              (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | 
              (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | 
              (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    
    assign S = P ^ {C7, C6, C5, C4, C3, C2, C1, Cin};
    assign Cout = C8;
    
    // Group generate and propagate
    assign G_group = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | 
                    (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | 
                    (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | 
                    (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]);
    assign P_group = &P;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    wire [3:0] G;
    wire [3:0] P;
    
    // First level 8-bit blocks
    manchester_carry_8bit block0 (
        .A(A[8:1]), .B(B[8:1]), .Cin(1'b0),
        .S(S[8:1]), .Cout(carry[0]), 
        .G_group(G[0]), .P_group(P[0])
    );
    
    manchester_carry_8bit block1 (
        .A(A[16:9]), .B(B[16:9]), .Cin(carry[0]),
        .S(S[16:9]), .Cout(carry[1]), 
        .G_group(G[1]), .P_group(P[1])
    );
    
    manchester_carry_8bit block2 (
        .A(A[24:17]), .B(B[24:17]), .Cin(carry[1]),
        .S(S[24:17]), .Cout(carry[2]), 
        .G_group(G[2]), .P_group(P[2])
    );
    
    manchester_carry_8bit block3 (
        .A(A[32:25]), .B(B[32:25]), .Cin(carry[2]),
        .S(S[32:25]), .Cout(carry[3]), 
        .G_group(G[3]), .P_group(P[3])
    );
    
    // Top-level carry lookahead
    wire C8 = G[0] | (P[0] & 1'b0);
    wire C16 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & 1'b0);
    wire C24 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & 1'b0);
    wire C32 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
              (P[3] & P[2] & P[1] & P[0] & 1'b0);
    
    // Final carry out
    assign C32 = carry[3];
endmodule