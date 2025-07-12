module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,
    output Gg
);
    wire [3:0] P, G;
    wire [4:0] C;
    
    // Ling's modified generate/propagate
    assign P = A ^ B;
    assign G = A & B;
    
    // Carry computation (Ling's scheme)
    wire [3:0] H; // Ling's pseudo-carry
    assign H[0] = G[0] | (P[0] & Cin);
    assign H[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign H[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign H[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
                 (P[3] & P[2] & P[1] & P[0] & Cin);
    
    // Final carry computation
    assign C[0] = Cin;
    assign C[1] = H[0];
    assign C[2] = H[1] | (P[1] & P[0] & Cin);
    assign C[3] = H[2] | (P[2] & P[1] & P[0] & Cin);
    assign C[4] = H[3] | (P[3] & P[2] & P[1] & P[0] & Cin);
    
    // Sum computation
    assign S = P ^ C[3:0];
    
    // Group signals
    assign Pg = &P;
    assign Gg = H[3];
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Pg,
    output Gg
);
    wire Pg0, Gg0, Pg1, Gg1;
    wire C4;
    
    // Two 4-bit CLAs
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Pg(Pg0), .Gg(Gg0));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(C4), .S(S[7:4]), .Pg(Pg1), .Gg(Gg1));
    
    // Carry lookahead between 4-bit blocks
    assign C4 = Gg0 | (Pg0 & Cin);
    
    // Group signals
    assign Pg = Pg0 & Pg1;
    assign Gg = Gg1 | (Pg1 & Gg0);
endmodule

module csel_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Pg,
    output Gg
);
    wire [15:0] S0, S1;
    wire Pg0, Gg0, Pg1, Gg1;
    wire C8_0, C8_1;
    wire sel;
    
    // Two 8-bit CLAs with carry=0 and carry=1
    cla_8bit cla0_0 (.A(A[7:0]), .B(B[7:0]), .Cin(1'b0), .S(S0[7:0]), .Pg(Pg0), .Gg(Gg0));
    cla_8bit cla0_1 (.A(A[7:0]), .B(B[7:0]), .Cin(1'b1), .S(S1[7:0]), .Pg(), .Gg());
    
    cla_8bit cla1_0 (.A(A[15:8]), .B(B[15:8]), .Cin(C8_0), .S(S0[15:8]), .Pg(Pg1), .Gg(Gg1));
    cla_8bit cla1_1 (.A(A[15:8]), .B(B[15:8]), .Cin(C8_1), .S(S1[15:8]), .Pg(), .Gg());
    
    // Compute intermediate carries
    assign C8_0 = Gg0 | (Pg0 & 1'b0);
    assign C8_1 = Gg0 | (Pg0 & 1'b1);
    
    // Final carry select
    assign sel = Gg0 | (Pg0 & Cin);
    assign S = sel ? S1 : S0;
    
    // Group signals
    assign Pg = Pg0 & Pg1;
    assign Gg = Gg1 | (Pg1 & Gg0);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire Pg0, Gg0, Pg1, Gg1;
    wire C16;
    
    // Two 16-bit carry-select adders
    csel_16bit csel0 (.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .S(S[16:1]), .Pg(Pg0), .Gg(Gg0));
    csel_16bit csel1 (.A(A[32:17]), .B(B[32:17]), .Cin(C16), .S(S[32:17]), .Pg(Pg1), .Gg(Gg1));
    
    // Carry lookahead between 16-bit blocks
    assign C16 = Gg0 | (Pg0 & 1'b0);
    assign C32 = Gg1 | (Pg1 & Gg0);
endmodule