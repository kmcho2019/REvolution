module pg_generator(
    input [7:0] A,
    input [7:0] B,
    output [7:0] G,
    output [7:0] P
);
    assign G = A & B;
    assign P = A ^ B;
endmodule

module carry_generator(
    input [7:0] G,
    input [7:0] P,
    input Cin,
    output [8:0] C
);
    // Parallel prefix computation (Brent-Kung tree)
    wire [7:0] G1, P1;
    wire [7:0] G2, P2;
    
    // First level
    assign G1[0] = G[0];
    assign P1[0] = P[0];
    assign {G1[1], P1[1]} = {G[1], P[1]};
    assign {G1[2], P1[2]} = {G[2], P[2]};
    assign {G1[3], P1[3]} = {G[3], P[3]};
    
    // Second level
    assign {G2[1], P2[1]} = {G1[1] | (P1[1] & G1[0]), P1[1] & P1[0]};
    assign {G2[3], P2[3]} = {G1[3] | (P1[3] & G1[2]), P1[3] & P1[2]};
    
    // Third level
    assign {G2[5], P2[5]} = {G1[5] | (P1[5] & G2[3]), P1[5] & P2[3]};
    assign {G2[7], P2[7]} = {G1[7] | (P1[7] & G2[5]), P1[7] & P2[5]};
    
    // Generate all carries
    assign C[0] = Cin;
    assign C[1] = G1[0] | (P1[0] & C[0]);
    assign C[2] = G2[1] | (P2[1] & C[0]);
    assign C[3] = G1[2] | (P1[2] & C[2]);
    assign C[4] = G2[3] | (P2[3] & C[0]);
    assign C[5] = G1[4] | (P1[4] & C[4]);
    assign C[6] = G2[5] | (P2[5] & C[0]);
    assign C[7] = G1[6] | (P1[6] & C[6]);
    assign C[8] = G2[7] | (P2[7] & C[0]);
endmodule

module cla_8bit(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [7:0] G, P;
    wire [8:0] C;
    
    pg_generator pg_gen(.A(A), .B(B), .G(G), .P(P));
    carry_generator carry_gen(.G(G), .P(P), .Cin(Cin), .C(C));
    
    assign S = P ^ C[7:0];
    assign Cout = C[8];
endmodule

module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    wire [3:0] carry0, carry1; // Speculative carries
    
    // First level: 8-bit blocks with carry speculation
    cla_8bit block0(.A(A[8:1]), .B(B[8:1]), .Cin(1'b0), .S(S[8:1]), .Cout(carry0[0]));
    cla_8bit block0_1(.A(A[8:1]), .B(B[8:1]), .Cin(1'b1), .S(), .Cout(carry1[0]));
    
    cla_8bit block1(.A(A[16:9]), .B(B[16:9]), .Cin(1'b0), .S(S[16:9]), .Cout(carry0[1]));
    cla_8bit block1_1(.A(A[16:9]), .B(B[16:9]), .Cin(1'b1), .S(), .Cout(carry1[1]));
    
    cla_8bit block2(.A(A[24:17]), .B(B[24:17]), .Cin(1'b0), .S(S[24:17]), .Cout(carry0[2]));
    cla_8bit block2_1(.A(A[24:17]), .B(B[24:17]), .Cin(1'b1), .S(), .Cout(carry1[2]));
    
    cla_8bit block3(.A(A[32:25]), .B(B[32:25]), .Cin(1'b0), .S(S[32:25]), .Cout(carry0[3]));
    cla_8bit block3_1(.A(A[32:25]), .B(B[32:25]), .Cin(1'b1), .S(), .Cout(carry1[3]));
    
    // Carry resolution logic
    wire actual_carry1 = carry0[0] ? carry1[1] : carry0[1];
    wire actual_carry2 = actual_carry1 ? carry1[2] : carry0[2];
    assign C32 = actual_carry2 ? carry1[3] : carry0[3];
    
    // Final sum selection
    assign S[16:9] = carry0[0] ? (A[16:9] ^ B[16:9] ^ {8{1'b1}}) : S[16:9];
    assign S[24:17] = actual_carry1 ? (A[24:17] ^ B[24:17] ^ {8{1'b1}}) : S[24:17];
    assign S[32:25] = actual_carry2 ? (A[32:25] ^ B[32:25] ^ {8{1'b1}}) : S[32:25];
endmodule