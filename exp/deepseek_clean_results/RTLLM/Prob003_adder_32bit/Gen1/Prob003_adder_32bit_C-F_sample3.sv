module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Gg,
    output Pg
);
    wire [3:0] G, P;
    wire [3:1] C;
    
    // Generate and Propagate terms
    assign G = A & B;
    assign P = A ^ B;
    
    // Carry computation
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    
    // Sum computation
    assign S = P ^ {C, Cin};
    
    // Block Generate and Propagate
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign Pg = &P;
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] G, P;
    wire [4:1] C;
    
    // First 4-bit block
    cla_4bit block0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .Gg(G[0]),
        .Pg(P[0])
    );
    
    // Second 4-bit block
    cla_4bit block1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C[1]),
        .S(S[7:4]),
        .Gg(G[1]),
        .Pg(P[1])
    );
    
    // Third 4-bit block
    cla_4bit block2 (
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(C[2]),
        .S(S[11:8]),
        .Gg(G[2]),
        .Pg(P[2])
    );
    
    // Fourth 4-bit block
    cla_4bit block3 (
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(C[3]),
        .S(S[15:12]),
        .Gg(G[3]),
        .Pg(P[3])
    );
    
    // Carry lookahead between 4-bit blocks
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
                 (P[3] & P[2] & P[1] & P[0] & Cin);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    
    // Lower 16-bit block
    cla_16bit low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );
    
    // Upper 16-bit block
    cla_16bit high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule