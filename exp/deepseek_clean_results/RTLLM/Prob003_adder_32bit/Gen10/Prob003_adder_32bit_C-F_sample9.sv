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
    assign G = G_bit[3] | (P_bit[3] & (G_bit[2] | (P_bit[2] & (G_bit[1] | (P_bit[1] & G_bit[0]))));
    assign P = P_bit[3] & P_bit[2] & P_bit[1] & P_bit[0];
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] G, P;
    wire [3:0] carry;
    
    // First level carry lookahead (4-bit blocks)
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .G(G[0]), .P(P[0]));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), .S(S[7:4]), .G(G[1]), .P(P[1]));
    cla_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), .S(S[11:8]), .G(G[2]), .P(P[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), .S(S[15:12]), .G(G[3]), .P(P[3]));
    
    // Second level carry lookahead (between 4-bit blocks)
    assign carry[0] = G[0] | (P[0] & Cin);
    assign carry[1] = G[1] | (P[1] & carry[0]);
    assign carry[2] = G[2] | (P[2] & carry[1]);
    assign carry[3] = G[3] | (P[3] & carry[2]);
    
    assign Cout = carry[3];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire G_low, P_low, G_high, P_high;
    wire C16;
    
    // Lower 16 bits with lookahead
    cla_16bit low (
        .A(A[16:1]), 
        .B(B[16:1]), 
        .Cin(1'b0), 
        .S(S[16:1]), 
        .Cout(C16)
    );
    
    // Upper 16 bits with lookahead
    cla_16bit high (
        .A(A[32:17]), 
        .B(B[32:17]), 
        .Cin(C16), 
        .S(S[32:17]), 
        .Cout(C32)
    );
endmodule