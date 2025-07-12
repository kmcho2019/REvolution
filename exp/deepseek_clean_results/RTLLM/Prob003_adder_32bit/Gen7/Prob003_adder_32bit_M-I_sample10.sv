module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout,
    output Gg,
    output Pg
);
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    wire [8:0] C;
    
    // First level lookahead (within 8-bit block)
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]);
    
    // Group generate/propagate for second level lookahead
    assign Gg = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | 
               (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) |
               (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | 
               (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) |
               (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]);
               
    assign Pg = &P;
    
    assign Cout = C[8];
    assign S = P ^ C[7:0];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    wire [3:0] Gg, Pg;
    
    // First level 8-bit CLAs
    cla_8bit cla0 (.A(A[8:1]),   .B(B[8:1]),   .Cin(1'b0),    .S(S[8:1]),   .Cout(carry[0]), .Gg(Gg[0]), .Pg(Pg[0]));
    cla_8bit cla1 (.A(A[16:9]),  .B(B[16:9]),  .Cin(carry[0]), .S(S[16:9]),  .Cout(carry[1]), .Gg(Gg[1]), .Pg(Pg[1]));
    cla_8bit cla2 (.A(A[24:17]), .B(B[24:17]), .Cin(carry[1]), .S(S[24:17]), .Cout(carry[2]), .Gg(Gg[2]), .Pg(Pg[2]));
    cla_8bit cla3 (.A(A[32:25]), .B(B[32:25]), .Cin(carry[2]), .S(S[32:25]), .Cout(carry[3]), .Gg(Gg[3]), .Pg(Pg[3]));
    
    // Second level lookahead for faster carry propagation
    wire carry1 = Gg[0] | (Pg[0] & 1'b0);
    wire carry2 = Gg[1] | (Pg[1] & carry1);
    wire carry3 = Gg[2] | (Pg[2] & carry2);
    assign C32 = Gg[3] | (Pg[3] & carry3);
endmodule