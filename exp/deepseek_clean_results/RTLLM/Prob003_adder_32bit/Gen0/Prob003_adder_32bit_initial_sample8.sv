module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,
    output Gg
);
    wire [3:0] P, G;
    wire [3:0] C;
    wire [3:1] carry;
    
    // Generate P and G for each bit
    assign P = A ^ B;
    assign G = A & B;
    
    // Carry lookahead logic
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    
    // Sum calculation
    assign S = P ^ C;
    
    // Group propagate and generate
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Pg,
    output Gg
);
    wire [3:0] P, G;
    wire [3:0] C;
    
    // First level carry (between 4-bit blocks)
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    
    // Instantiate four 4-bit CLAs
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(C[0]), .S(S[3:0]), .Pg(P[0]), .Gg(G[0]));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(C[1]), .S(S[7:4]), .Pg(P[1]), .Gg(G[1]));
    cla_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(C[2]), .S(S[11:8]), .Pg(P[2]), .Gg(G[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(C[3]), .S(S[15:12]), .Pg(P[3]), .Gg(G[3]));
    
    // Group propagate and generate
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire P0, G0, P1, G1;
    wire carry16;
    
    // First 16-bit CLA
    cla_16bit cla0 (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Pg(P0),
        .Gg(G0)
    );
    
    // Second 16-bit CLA
    cla_16bit cla1 (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(carry16),
        .S(S[32:17]),
        .Pg(P1),
        .Gg(G1)
    );
    
    // Carry between 16-bit blocks
    assign carry16 = G0 | (P0 & 1'b0);
    assign C32 = G1 | (P1 & G0);
endmodule