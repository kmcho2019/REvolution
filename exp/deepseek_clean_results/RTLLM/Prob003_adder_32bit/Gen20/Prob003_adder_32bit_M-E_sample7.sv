module cla_4bit_base (
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
    
    // Carry computation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    
    // Sum generation
    assign S = P ^ C;
    
    // Block propagate/generate
    assign Pg = &P;
    assign Gg = G[3] | (G[2] & P[3]) | (G[1] & P[3] & P[2]) | (G[0] & P[3] & P[2] & P[1]);
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Pg,
    output Gg,
    output Cout
);
    wire p0, g0, p1, g1;
    wire carry_mid;
    
    // Lower 4-bit block
    cla_4bit_base cla0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .Pg(p0),
        .Gg(g0)
    );
    
    // Upper 4-bit block
    cla_4bit_base cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(carry_mid),
        .S(S[7:4]),
        .Pg(p1),
        .Gg(g1)
    );
    
    // Intermediate carry computation
    assign carry_mid = g0 | (p0 & Cin);
    
    // Block propagate/generate
    assign Pg = p0 & p1;
    assign Gg = g1 | (g0 & p1);
    assign Cout = Gg | (Pg & Cin);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] Pg, Gg;
    wire [3:0] carry;
    
    // Block 0 (bits 1-8)
    cla_8bit block0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(1'b0),
        .S(S[8:1]),
        .Pg(Pg[0]),
        .Gg(Gg[0]),
        .Cout(carry[0])
    );
    
    // Block 1 (bits 9-16)
    cla_8bit block1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(carry[0]),
        .S(S[16:9]),
        .Pg(Pg[1]),
        .Gg(Gg[1]),
        .Cout(carry[1])
    );
    
    // Block 2 (bits 17-24)
    cla_8bit block2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(carry[1]),
        .S(S[24:17]),
        .Pg(Pg[2]),
        .Gg(Gg[2]),
        .Cout(carry[2])
    );
    
    // Block 3 (bits 25-32)
    cla_8bit block3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(carry[2]),
        .S(S[32:25]),
        .Pg(Pg[3]),
        .Gg(Gg[3]),
        .Cout(carry[3])
    );
    
    // Final carry out
    assign C32 = carry[3];
    
    // Alternative hierarchical carry computation (optional)
    // wire [1:0] Pg_high = Pg[3] & Pg[2];
    // wire [1:0] Gg_high = Gg[3] | (Gg[2] & Pg[3]);
    // assign C32 = Gg_high | (Pg_high & carry[1]);
endmodule