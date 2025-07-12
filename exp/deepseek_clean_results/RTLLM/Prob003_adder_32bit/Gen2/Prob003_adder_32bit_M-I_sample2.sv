module adder_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,
    output Gg
);
    wire [3:0] P, G;
    wire [4:0] C;
    
    // Generate and Propagate
    assign P = A ^ B;
    assign G = A & B;
    
    // Brent-Kung prefix network (2 levels)
    // First level
    wire [3:0] P1, G1;
    assign {P1[0], G1[0]} = {P[0], G[0]};
    assign P1[1] = P[1] & P[0];
    assign G1[1] = G[1] | (P[1] & G[0]);
    assign P1[2] = P[2] & P[1];
    assign G1[2] = G[2] | (P[2] & G[1]);
    assign P1[3] = P[3] & P[2];
    assign G1[3] = G[3] | (P[3] & G[2]);
    
    // Second level
    wire [3:0] P2, G2;
    assign {P2[1:0], G2[1:0]} = {P1[1:0], G1[1:0]};
    assign P2[2] = P1[2] & P1[0];
    assign G2[2] = G1[2] | (P1[2] & G1[0]);
    assign P2[3] = P1[3] & P1[1];
    assign G2[3] = G1[3] | (P1[3] & G1[1]);
    
    // Final carries
    assign C[0] = Cin;
    assign C[1] = G1[0] | (P1[0] & C[0]);
    assign C[2] = G2[1] | (P2[1] & C[0]);
    assign C[3] = G2[2] | (P2[2] & C[0]);
    assign C[4] = G2[3] | (P2[3] & C[0]);
    
    // Sum computation
    assign S = P ^ C[3:0];
    
    // Group propagate and generate (optimized)
    assign Pg = &P;
    assign Gg = G2[3];
endmodule

module adder_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Pg,
    output Gg
);
    wire [1:0] Pg4, Gg4;
    wire [2:0] C;
    
    assign C[0] = Cin;
    
    // Instantiate two 4-bit CLAs
    adder_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(C[0]), .S(S[3:0]), .Pg(Pg4[0]), .Gg(Gg4[0]));
    adder_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(C[1]), .S(S[7:4]), .Pg(Pg4[1]), .Gg(Gg4[1]));
    
    // Carry lookahead between 4-bit blocks
    assign C[1] = Gg4[0] | (Pg4[0] & C[0]);
    assign C[2] = Gg4[1] | (Pg4[1] & C[0]);
    
    // Group propagate and generate
    assign Pg = Pg4[1] & Pg4[0];
    assign Gg = Gg4[1] | (Pg4[1] & Gg4[0]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] Pg8, Gg8;
    wire [4:0] C;
    
    assign C[0] = 1'b0;
    
    // Instantiate four 8-bit CLAs
    adder_8bit cla0 (.A(A[8:1]), .B(B[8:1]), .Cin(C[0]), .S(S[8:1]), .Pg(Pg8[0]), .Gg(Gg8[0]));
    adder_8bit cla1 (.A(A[16:9]), .B(B[16:9]), .Cin(C[1]), .S(S[16:9]), .Pg(Pg8[1]), .Gg(Gg8[1]));
    adder_8bit cla2 (.A(A[24:17]), .B(B[24:17]), .Cin(C[2]), .S(S[24:17]), .Pg(Pg8[2]), .Gg(Gg8[2]));
    adder_8bit cla3 (.A(A[32:25]), .B(B[32:25]), .Cin(C[3]), .S(S[32:25]), .Pg(Pg8[3]), .Gg(Gg8[3]));
    
    // Carry lookahead between 8-bit blocks (optimized 2-level)
    // First level
    wire [3:0] P1, G1;
    assign {P1[0], G1[0]} = {Pg8[0], Gg8[0]};
    assign P1[1] = Pg8[1] & Pg8[0];
    assign G1[1] = Gg8[1] | (Pg8[1] & Gg8[0]);
    assign P1[2] = Pg8[2] & Pg8[1];
    assign G1[2] = Gg8[2] | (Pg8[2] & Gg8[1]);
    assign P1[3] = Pg8[3] & Pg8[2];
    assign G1[3] = Gg8[3] | (Pg8[3] & Gg8[2]);
    
    // Second level
    wire [3:0] P2, G2;
    assign {P2[1:0], G2[1:0]} = {P1[1:0], G1[1:0]};
    assign P2[2] = P1[2] & P1[0];
    assign G2[2] = G1[2] | (P1[2] & G1[0]);
    assign P2[3] = P1[3] & P1[1];
    assign G2[3] = G1[3] | (P1[3] & G1[1]);
    
    // Final carries
    assign C[1] = G1[0] | (P1[0] & C[0]);
    assign C[2] = G2[1] | (P2[1] & C[0]);
    assign C[3] = G2[2] | (P2[2] & C[0]);
    assign C[4] = G2[3] | (P2[3] & C[0]);
    
    assign C32 = C[4];
endmodule