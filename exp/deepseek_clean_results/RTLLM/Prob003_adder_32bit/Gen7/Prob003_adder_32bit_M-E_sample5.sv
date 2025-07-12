module cla_4bit_optimized (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G_out,
    output P_out
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    
    assign S = P ^ C;
    assign G_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign P_out = P[3] & P[2] & P[1] & P[0];
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [1:0] G, P;
    wire [1:0] C;
    
    cla_4bit_optimized cla0 (
        .A(A[3:0]), 
        .B(B[3:0]), 
        .Cin(Cin), 
        .S(S[3:0]), 
        .G_out(G[0]), 
        .P_out(P[0])
    );
    
    cla_4bit_optimized cla1 (
        .A(A[7:4]), 
        .B(B[7:4]), 
        .Cin(C[1]), 
        .S(S[7:4]), 
        .G_out(G[1]), 
        .P_out(P[1])
    );
    
    // Carry lookahead between 4-bit blocks
    assign C[1] = G[0] | (P[0] & Cin);
    assign Cout = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] G, P;
    wire [3:0] C;
    
    // First 8-bit block
    cla_8bit block0 (
        .A(A[8:1]), 
        .B(B[8:1]), 
        .Cin(1'b0), 
        .S(S[8:1]), 
        .Cout(C[0])
    );
    
    // Next three 8-bit blocks
    cla_8bit block1 (
        .A(A[16:9]), 
        .B(B[16:9]), 
        .Cin(C[0]), 
        .S(S[16:9]), 
        .Cout(C[1])
    );
    
    cla_8bit block2 (
        .A(A[24:17]), 
        .B(B[24:17]), 
        .Cin(C[1]), 
        .S(S[24:17]), 
        .Cout(C[2])
    );
    
    // Final 8-bit block
    cla_8bit block3 (
        .A(A[32:25]), 
        .B(B[32:25]), 
        .Cin(C[2]), 
        .S(S[32:25]), 
        .Cout(C[3])
    );
    
    // Global carry lookahead
    assign C32 = C[3];
endmodule