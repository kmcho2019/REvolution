module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Pg,
    output Gg
);
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    wire [7:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    
    assign S = P ^ C;
    assign Pg = &P;  // Block propagate (all bits propagate)
    assign Gg = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | 
               (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) |
               (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | 
               (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) |
               (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] Pg, Gg;
    wire [3:0] carry;
    
    // First 8-bit block (no carry in)
    cla_8bit block0 (
        .A(A[8:1]), 
        .B(B[8:1]), 
        .Cin(1'b0), 
        .S(S[8:1]), 
        .Pg(Pg[0]), 
        .Gg(Gg[0])
    );
    
    // Subsequent blocks with carry lookahead
    cla_8bit block1 (
        .A(A[16:9]), 
        .B(B[16:9]), 
        .Cin(Gg[0] | (Pg[0] & 1'b0)), 
        .S(S[16:9]), 
        .Pg(Pg[1]), 
        .Gg(Gg[1])
    );
    
    cla_8bit block2 (
        .A(A[24:17]), 
        .B(B[24:17]), 
        .Cin(Gg[1] | (Pg[1] & Gg[0])), 
        .S(S[24:17]), 
        .Pg(Pg[2]), 
        .Gg(Gg[2])
    );
    
    cla_8bit block3 (
        .A(A[32:25]), 
        .B(B[32:25]), 
        .Cin(Gg[2] | (Pg[2] & Gg[1]) | (Pg[2] & Pg[1] & Gg[0])), 
        .S(S[32:25]), 
        .Pg(Pg[3]), 
        .Gg(C32)  // Final carry out
    );
endmodule