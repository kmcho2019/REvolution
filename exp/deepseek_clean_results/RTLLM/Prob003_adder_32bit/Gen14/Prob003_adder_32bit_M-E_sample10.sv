module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout,
    output G,
    output P
);
    wire [3:0] G_bit = A & B;
    wire [3:0] P_bit = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G_bit[0] | (P_bit[0] & C[0]);
    assign C[2] = G_bit[1] | (P_bit[1] & C[1]);
    assign C[3] = G_bit[2] | (P_bit[2] & C[2]);
    assign Cout = G_bit[3] | (P_bit[3] & C[3]);
    
    assign S = P_bit ^ C;
    assign G = &G_bit;  // Group generate
    assign P = &P_bit;  // Group propagate
endmodule

module super_cla_4bit (
    input [3:0] G,
    input [3:0] P,
    input Cin,
    output [3:0] Cout
);
    assign Cout[0] = G[0] | (P[0] & Cin);
    assign Cout[1] = G[1] | (P[1] & Cout[0]);
    assign Cout[2] = G[2] | (P[2] & Cout[1]);
    assign Cout[3] = G[3] | (P[3] & Cout[2]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [7:0] G, P;  // Generate/Propagate from each 4-bit block
    wire [7:0] carry_out;
    wire [1:0] super_carry;
    
    // First 16 bits (lower half)
    cla_4bit cla0 (.A(A[4:1]),   .B(B[4:1]),   .Cin(1'b0),     .S(S[4:1]),   .Cout(carry_out[0]), .G(G[0]), .P(P[0]));
    cla_4bit cla1 (.A(A[8:5]),   .B(B[8:5]),   .Cin(carry_out[0]), .S(S[8:5]),   .Cout(carry_out[1]), .G(G[1]), .P(P[1]));
    cla_4bit cla2 (.A(A[12:9]),  .B(B[12:9]),  .Cin(carry_out[1]), .S(S[12:9]),  .Cout(carry_out[2]), .G(G[2]), .P(P[2]));
    cla_4bit cla3 (.A(A[16:13]), .B(B[16:13]), .Cin(carry_out[2]), .S(S[16:13]), .Cout(carry_out[3]), .G(G[3]), .P(P[3]));
    
    // Second 16 bits (upper half)
    cla_4bit cla4 (.A(A[20:17]), .B(B[20:17]), .Cin(super_carry[0]), .S(S[20:17]), .Cout(carry_out[4]), .G(G[4]), .P(P[4]));
    cla_4bit cla5 (.A(A[24:21]), .B(B[24:21]), .Cin(carry_out[4]), .S(S[24:21]), .Cout(carry_out[5]), .G(G[5]), .P(P[5]));
    cla_4bit cla6 (.A(A[28:25]), .B(B[28:25]), .Cin(carry_out[5]), .S(S[28:25]), .Cout(carry_out[6]), .G(G[6]), .P(P[6]));
    cla_4bit cla7 (.A(A[32:29]), .B(B[32:29]), .Cin(carry_out[6]), .S(S[32:29]), .Cout(carry_out[7]), .G(G[7]), .P(P[7]));
    
    // Super CLAs for 16-bit segments
    super_cla_4bit super0 (.G(G[3:0]), .P(P[3:0]), .Cin(1'b0), .Cout({super_carry[0], open, open, open}));
    super_cla_4bit super1 (.G(G[7:4]), .P(P[7:4]), .Cin(super_carry[0]), .Cout({C32, open, open, open}));
endmodule