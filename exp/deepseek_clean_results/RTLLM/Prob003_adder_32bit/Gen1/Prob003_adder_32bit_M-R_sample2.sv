module adder_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Pg,
    output Gg
);
    wire [7:0] P, G;
    wire [7:0] C;
    
    // Generate and propagate signals
    assign P = A ^ B;
    assign G = A & B;
    
    // Carry calculations
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & C[3]);
    assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & C[3]);
    assign C[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | 
                 (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & C[3]);
    
    // Sum calculation
    assign S = P ^ C;
    
    // Group propagate and generate
    assign Pg = &P;
    assign Gg = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | 
               (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) |
               (P[7] & P[6] & P[5] & P[4] & P[3] & C[3]);
endmodule

module adder_32bit (
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output Cout
);
    wire [3:0] Pg, Gg;
    wire [3:1] C;
    
    // Instantiate four 8-bit CLA blocks
    adder_8bit cla0 (.A(A[7:0]), .B(B[7:0]), .Cin(1'b0), .S(S[7:0]), .Pg(Pg[0]), .Gg(Gg[0]));
    adder_8bit cla1 (.A(A[15:8]), .B(B[15:8]), .Cin(C[1]), .S(S[15:8]), .Pg(Pg[1]), .Gg(Gg[1]));
    adder_8bit cla2 (.A(A[23:16]), .B(B[23:16]), .Cin(C[2]), .S(S[23:16]), .Pg(Pg[2]), .Gg(Gg[2]));
    adder_8bit cla3 (.A(A[31:24]), .B(B[31:24]), .Cin(C[3]), .S(S[31:24]), .Pg(Pg[3]), .Gg(Gg[3]));
    
    // Carry lookahead between 8-bit blocks
    assign C[1] = Gg[0] | (Pg[0] & 1'b0);
    assign C[2] = Gg[1] | (Pg[1] & Gg[0]) | (Pg[1] & Pg[0] & 1'b0);
    assign C[3] = Gg[2] | (Pg[2] & Gg[1]) | (Pg[2] & Pg[1] & Gg[0]) | (Pg[2] & Pg[1] & Pg[0] & 1'b0);
    
    // Final carry out
    assign Cout = Gg[3] | (Pg[3] & Gg[2]) | (Pg[3] & Pg[2] & Gg[1]) | 
                 (Pg[3] & Pg[2] & Pg[1] & Gg[0]) | (Pg[3] & Pg[2] & Pg[1] & Pg[0] & 1'b0);
endmodule