module cla_4bit_optimized (
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
    
    assign G = &(G_bit[3:1] | (P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]);
    assign P = &P_bit;
    assign S = P_bit ^ C;
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [1:0] carry;
    wire [1:0] G;
    wire [1:0] P;
    
    cla_4bit_optimized cla0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .Cout(),
        .G(G[0]),
        .P(P[0])
    );
    
    cla_4bit_optimized cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(G[0] | (P[0] & Cin)),
        .S(S[7:4]),
        .Cout(),
        .G(G[1]),
        .P(P[1])
    );
    
    assign Cout = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
endmodule

module adder_32bit_optimized (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    
    cla_8bit block0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(1'b0),
        .S(S[8:1]),
        .Cout(carry[0])
    );
    
    cla_8bit block1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(carry[0]),
        .S(S[16:9]),
        .Cout(carry[1])
    );
    
    cla_8bit block2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(carry[1]),
        .S(S[24:17]),
        .Cout(carry[2])
    );
    
    cla_8bit block3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(carry[2]),
        .S(S[32:25]),
        .Cout(carry[3])
    );
    
    assign C32 = carry[3];
endmodule