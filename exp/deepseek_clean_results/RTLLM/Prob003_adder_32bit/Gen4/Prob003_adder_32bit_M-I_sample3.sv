module cla_4bit_opt (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,        // Block propagate
    output Gg,        // Block generate
    output Cout
);
    wire [3:0] P, G, C;
    
    // Individual bit propagate and generate
    assign P = A ^ B;
    assign G = A & B;
    
    // Optimized carry computation - balanced tree structure
    wire [3:0] PP, GG;
    assign GG[0] = G[0];
    assign PP[0] = P[0];
    
    // First level
    assign GG[1] = G[1] | (P[1] & GG[0]);
    assign PP[1] = P[1] & PP[0];
    
    // Second level
    assign GG[2] = G[2] | (P[2] & GG[1]);
    assign PP[2] = P[2] & PP[1];
    
    // Third level
    assign GG[3] = G[3] | (P[3] & GG[2]);
    assign PP[3] = P[3] & PP[2];
    
    // Carry computation
    assign C[0] = Cin;
    assign C[1] = GG[0] | (PP[0] & Cin);
    assign C[2] = GG[1] | (PP[1] & Cin);
    assign C[3] = GG[2] | (PP[2] & Cin);
    assign Cout = GG[3] | (PP[3] & Cin);
    
    // Sum computation
    assign S = P ^ C;
    
    // Simplified block propagate and generate
    assign Pg = PP[3];
    assign Gg = GG[3];
endmodule

module cla_16bit_opt (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] Pg, Gg;  // 4-bit block P/G signals
    wire [3:0] C;        // Inter-block carries
    
    // Instantiate four optimized 4-bit CLAs
    cla_4bit_opt cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), 
                     .Pg(Pg[0]), .Gg(Gg[0]), .Cout());
    cla_4bit_opt cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(C[0]), .S(S[7:4]), 
                     .Pg(Pg[1]), .Gg(Gg[1]), .Cout());
    cla_4bit_opt cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(C[1]), .S(S[11:8]), 
                     .Pg(Pg[2]), .Gg(Gg[2]), .Cout());
    cla_4bit_opt cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(C[2]), .S(S[15:12]), 
                     .Pg(Pg[3]), .Gg(Gg[3]), .Cout());
    
    // Optimized carry lookahead - parallel prefix structure
    wire [3:0] GG, PP;
    
    // First level
    assign GG[0] = Gg[0];
    assign PP[0] = Pg[0];
    
    // Second level
    assign GG[1] = Gg[1] | (Pg[1] & GG[0]);
    assign PP[1] = Pg[1] & PP[0];
    
    // Third level
    assign GG[2] = Gg[2] | (Pg[2] & GG[1]);
    assign PP[2] = Pg[2] & PP[1];
    
    // Fourth level
    assign GG[3] = Gg[3] | (Pg[3] & GG[2]);
    assign PP[3] = Pg[3] & PP[2];
    
    // Carry computation
    assign C[0] = GG[0] | (PP[0] & Cin);
    assign C[1] = GG[1] | (PP[1] & Cin);
    assign C[2] = GG[2] | (PP[2] & Cin);
    assign Cout = GG[3] | (PP[3] & Cin);
endmodule

module adder_32bit_opt (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;  // Carry between 16-bit blocks
    
    // Lower 16 bits
    cla_16bit_opt cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );
    
    // Upper 16 bits
    cla_16bit_opt cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule