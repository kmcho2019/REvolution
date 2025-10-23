module cla_4bit (
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
    wire [4:0] C;
    
    assign C[0] = Cin;
    
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(C[0]), .S(S[3:0]), .Pg(P[0]), .Gg(G[0]));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(C[1]), .S(S[7:4]), .Pg(P[1]), .Gg(G[1]));
    cla_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(C[2]), .S(S[11:8]), .Pg(P[2]), .Gg(G[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(C[3]), .S(S[15:12]), .Pg(P[3]), .Gg(G[3]));
    
    // Optimized carry lookahead logic
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    
    // Block propagate and generate
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire P0, G0, C16;
    
    cla_16bit low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Pg(P0),
        .Gg(G0)
    );
    
    cla_16bit high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Pg(),
        .Gg()
    );
    
    // Optimized intermediate carry calculation
    assign C16 = G0;
    
    // Final carry-out comes directly from the upper 16-bit block
    assign C32 = high.Gg | (high.Pg & C16);
endmodule