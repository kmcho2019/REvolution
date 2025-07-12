module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout,
    output Gout,
    output Pout
);
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    wire [7:0] C;
    
    // First level lookahead (4-bit)
    wire [1:0] GG, PP;
    wire [3:0] C4;
    
    assign GG[0] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign PP[0] = P[3] & P[2] & P[1] & P[0];
    assign C4[0] = Cin;
    assign C4[1] = G[0] | (P[0] & C4[0]);
    assign C4[2] = G[1] | (P[1] & C4[1]);
    assign C4[3] = G[2] | (P[2] & C4[2]);
    
    // Second level lookahead (next 4-bit)
    assign GG[1] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]);
    assign PP[1] = P[7] & P[6] & P[5] & P[4];
    assign C4[4] = GG[0] | (PP[0] & Cin);
    assign C4[5] = G[4] | (P[4] & C4[4]);
    assign C4[6] = G[5] | (P[5] & C4[5]);
    assign C4[7] = G[6] | (P[6] & C4[6]);
    
    assign Cout = GG[1] | (PP[1] & GG[0]) | (PP[1] & PP[0] & Cin);
    assign Gout = GG[1] | (PP[1] & GG[0]);
    assign Pout = PP[1] & PP[0];
    
    assign C = {C4[7:4], C4[3:0]};
    assign S = P ^ C;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    wire [3:0] GG, PP;
    
    cla_8bit cla0 (.A(A[8:1]), .B(B[8:1]), .Cin(1'b0), .S(S[8:1]), 
                  .Cout(carry[0]), .Gout(GG[0]), .Pout(PP[0]));
    cla_8bit cla1 (.A(A[16:9]), .B(B[16:9]), .Cin(carry[0]), .S(S[16:9]), 
                  .Cout(carry[1]), .Gout(GG[1]), .Pout(PP[1]));
    cla_8bit cla2 (.A(A[24:17]), .B(B[24:17]), .Cin(carry[1]), .S(S[24:17]), 
                  .Cout(carry[2]), .Gout(GG[2]), .Pout(PP[2]));
    cla_8bit cla3 (.A(A[32:25]), .B(B[32:25]), .Cin(carry[2]), .S(S[32:25]), 
                  .Cout(carry[3]), .Gout(GG[3]), .Pout(PP[3]));
    
    // Second level carry lookahead
    assign carry[0] = GG[0] | (PP[0] & 1'b0);
    assign carry[1] = GG[1] | (PP[1] & GG[0]) | (PP[1] & PP[0] & 1'b0);
    assign carry[2] = GG[2] | (PP[2] & GG[1]) | (PP[2] & PP[1] & GG[0]);
    assign carry[3] = GG[3] | (PP[3] & GG[2]) | (PP[3] & PP[2] & GG[1]);
    
    assign C32 = carry[3];
endmodule