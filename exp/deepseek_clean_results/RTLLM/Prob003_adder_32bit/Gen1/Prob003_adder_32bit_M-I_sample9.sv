module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,
    output Gg,
    output Cout
);
    wire [3:0] P, G;
    wire [3:0] C;
    
    assign P = A ^ B;
    assign G = A & B;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
    
    assign S = P ^ C;
    
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Pg,
    output Gg,
    output Cout
);
    wire [1:0] P, G;
    wire [1:0] C;
    
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Pg(P[0]), .Gg(G[0]), .Cout());
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(C[1]), .S(S[7:4]), .Pg(P[1]), .Gg(G[1]), .Cout());
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign Cout = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    
    assign Pg = P[0] & P[1];
    assign Gg = G[1] | (P[1] & G[0]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] Pg, Gg;
    wire [4:0] carry;
    wire A_zero = ~(|A);
    wire B_zero = ~(|B);
    
    assign carry[0] = 1'b0; // Initial carry-in is 0
    
    // Generate carry signals in parallel for better timing
    assign carry[1] = Gg[0] | (Pg[0] & carry[0]);
    assign carry[2] = Gg[1] | (Pg[1] & Gg[0]) | (Pg[1] & Pg[0] & carry[0]);
    assign carry[3] = Gg[2] | (Pg[2] & Gg[1]) | (Pg[2] & Pg[1] & Gg[0]) | (Pg[2] & Pg[1] & Pg[0] & carry[0]);
    assign carry[4] = Gg[3] | (Pg[3] & Gg[2]) | (Pg[3] & Pg[2] & Gg[1]) | (Pg[3] & Pg[2] & Pg[1] & Gg[0]) | (Pg[3] & Pg[2] & Pg[1] & Pg[0] & carry[0]);
    
    // Operand isolation for power savings
    wire [7:0] A0 = A_zero ? 8'b0 : A[8:1];
    wire [7:0] B0 = B_zero ? 8'b0 : B[8:1];
    wire [7:0] A1 = A_zero ? 8'b0 : A[16:9];
    wire [7:0] B1 = B_zero ? 8'b0 : B[16:9];
    wire [7:0] A2 = A_zero ? 8'b0 : A[24:17];
    wire [7:0] B2 = B_zero ? 8'b0 : B[24:17];
    wire [7:0] A3 = A_zero ? 8'b0 : A[32:25];
    wire [7:0] B3 = B_zero ? 8'b0 : B[32:25];
    
    cla_8bit cla0 (.A(A0), .B(B0), .Cin(carry[0]), .S(S[8:1]), .Pg(Pg[0]), .Gg(Gg[0]), .Cout());
    cla_8bit cla1 (.A(A1), .B(B1), .Cin(carry[1]), .S(S[16:9]), .Pg(Pg[1]), .Gg(Gg[1]), .Cout());
    cla_8bit cla2 (.A(A2), .B(B2), .Cin(carry[2]), .S(S[24:17]), .Pg(Pg[2]), .Gg(Gg[2]), .Cout());
    cla_8bit cla3 (.A(A3), .B(B3), .Cin(carry[3]), .S(S[32:25]), .Pg(Pg[3]), .Gg(Gg[3]), .Cout());
    
    assign C32 = carry[4];
endmodule