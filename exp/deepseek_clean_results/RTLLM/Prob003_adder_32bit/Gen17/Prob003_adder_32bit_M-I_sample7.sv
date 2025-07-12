module cla_4bit_opt (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,
    output Gg
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    
    assign S = P ^ C;
    assign Pg = &P;  // Group propagate
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module adder_32bit_opt (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [7:0] Pg, Gg;  // Group propagate/generate signals
    wire [7:0] C;        // Carry between groups
    
    // Generate carries using second-level lookahead
    assign C[0] = 1'b0;
    assign C[1] = Gg[0] | (Pg[0] & C[0]);
    assign C[2] = Gg[1] | (Pg[1] & C[1]);
    assign C[3] = Gg[2] | (Pg[2] & C[2]);
    assign C[4] = Gg[3] | (Pg[3] & C[3]);
    assign C[5] = Gg[4] | (Pg[4] & C[4]);
    assign C[6] = Gg[5] | (Pg[5] & C[5]);
    assign C[7] = Gg[6] | (Pg[6] & C[6]);
    assign C32 = Gg[7] | (Pg[7] & C[7]);
    
    // Instantiate 8x 4-bit CLA blocks
    cla_4bit_opt cla0 (.A(A[4:1]), .B(B[4:1]), .Cin(C[0]), .S(S[4:1]), .Pg(Pg[0]), .Gg(Gg[0]));
    cla_4bit_opt cla1 (.A(A[8:5]), .B(B[8:5]), .Cin(C[1]), .S(S[8:5]), .Pg(Pg[1]), .Gg(Gg[1]));
    cla_4bit_opt cla2 (.A(A[12:9]), .B(B[12:9]), .Cin(C[2]), .S(S[12:9]), .Pg(Pg[2]), .Gg(Gg[2]));
    cla_4bit_opt cla3 (.A(A[16:13]), .B(B[16:13]), .Cin(C[3]), .S(S[16:13]), .Pg(Pg[3]), .Gg(Gg[3]));
    cla_4bit_opt cla4 (.A(A[20:17]), .B(B[20:17]), .Cin(C[4]), .S(S[20:17]), .Pg(Pg[4]), .Gg(Gg[4]));
    cla_4bit_opt cla5 (.A(A[24:21]), .B(B[24:21]), .Cin(C[5]), .S(S[24:21]), .Pg(Pg[5]), .Gg(Gg[5]));
    cla_4bit_opt cla6 (.A(A[28:25]), .B(B[28:25]), .Cin(C[6]), .S(S[28:25]), .Pg(Pg[6]), .Gg(Gg[6]));
    cla_4bit_opt cla7 (.A(A[32:29]), .B(B[32:29]), .Cin(C[7]), .S(S[32:29]), .Pg(Pg[7]), .Gg(Gg[7]));
endmodule