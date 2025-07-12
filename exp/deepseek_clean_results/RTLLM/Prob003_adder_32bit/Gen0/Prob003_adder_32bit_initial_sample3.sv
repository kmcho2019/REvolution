module adder_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,
    output Gg
);
    wire [3:0] P, G;
    wire [3:1] C;
    
    // Generate P and G for each bit
    assign P = A ^ B;
    assign G = A & B;
    
    // Carry computation
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    
    // Sum computation
    assign S[0] = P[0] ^ Cin;
    assign S[1] = P[1] ^ C[1];
    assign S[2] = P[2] ^ C[2];
    assign S[3] = P[3] ^ C[3];
    
    // Block propagate and generate
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module adder_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout,
    output Pg,
    output Gg
);
    wire [3:0] P, G;
    wire [3:1] C;
    
    // First 4-bit block
    adder_4bit block0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .Pg(P[0]),
        .Gg(G[0])
    );
    
    // Second 4-bit block
    adder_4bit block1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C[1]),
        .S(S[7:4]),
        .Pg(P[1]),
        .Gg(G[1])
    );
    
    // Third 4-bit block
    adder_4bit block2 (
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(C[2]),
        .S(S[11:8]),
        .Pg(P[2]),
        .Gg(G[2])
    );
    
    // Fourth 4-bit block
    adder_4bit block3 (
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(C[3]),
        .S(S[15:12]),
        .Pg(P[3]),
        .Gg(G[3])
    );
    
    // Carry computation between 4-bit blocks
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
                 (P[3] & P[2] & P[1] & P[0] & Cin);
    
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
    wire C16;
    wire P0, G0, P1, G1;
    
    // First 16-bit block
    adder_16bit block0 (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .Pg(P0),
        .Gg(G0)
    );
    
    // Second 16-bit block
    adder_16bit block1 (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32),
        .Pg(P1),
        .Gg(G1)
    );
endmodule