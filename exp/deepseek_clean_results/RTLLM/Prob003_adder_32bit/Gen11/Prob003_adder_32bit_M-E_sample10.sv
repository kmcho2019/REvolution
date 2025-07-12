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
    
    // Carry lookahead tree
    wire [3:0] G1, P1;
    wire [1:0] G2, P2;
    wire G3, P3;
    
    // First level
    assign G1[0] = G[0] | (P[0] & Cin);
    assign P1[0] = P[0];
    assign G1[1] = G[1] | (P[1] & (G[0] | (P[0] & Cin)));
    assign P1[1] = P[1] & P[0];
    assign G1[2] = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin)))));
    assign P1[2] = P[2] & P[1] & P[0];
    assign G1[3] = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin)))))));
    assign P1[3] = P[3] & P[2] & P[1] & P[0];
    
    // Second level
    assign G2[0] = G1[1] | (P1[1] & G1[0]);
    assign P2[0] = P1[1] & P1[0];
    assign G2[1] = G1[3] | (P1[3] & G1[2]);
    assign P2[1] = P1[3] & P1[2];
    
    // Third level
    assign G3 = G2[1] | (P2[1] & G2[0]);
    assign P3 = P2[1] & P2[0];
    
    // Final carries
    assign C[0] = Cin;
    assign C[1] = G1[0];
    assign C[2] = G2[0];
    assign C[3] = G1[2];
    assign C[4] = G3;
    assign C[5] = G1[0] | (P1[0] & C[4]);
    assign C[6] = G1[1] | (P1[1] & C[4]);
    assign C[7] = G1[2] | (P1[2] & C[4]);
    
    assign S = P ^ C;
    assign Pg = P3;
    assign Gg = G3;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Lower 16 bits (pure CLA for minimum latency)
    wire P0, G0;
    cla_8bit low0 (.A(A[8:1]), .B(B[8:1]), .Cin(1'b0), .S(S[8:1]), .Pg(), .Gg());
    cla_8bit low1 (.A(A[16:9]), .B(B[16:9]), .Cin(G0), .S(S[16:9]), .Pg(P0), .Gg(G0));
    
    // Upper 16 bits (carry-select with lookahead)
    wire P1, G1, C16;
    wire [16:9] S_high0, S_high1;
    
    // Carry prediction
    assign C16 = G0 | (P0 & 1'b0);
    
    // Compute both possible sums
    cla_8bit high0_0 (.A(A[24:17]), .B(B[24:17]), .Cin(1'b0), .S(S_high0[16:9]), .Pg(), .Gg());
    cla_8bit high0_1 (.A(A[24:17]), .B(B[24:17]), .Cin(1'b1), .S(S_high1[16:9]), .Pg(P1), .Gg(G1));
    
    cla_8bit high1_0 (.A(A[32:25]), .B(B[32:25]), .Cin(1'b0), .S(S[32:25]), .Pg(), .Gg());
    cla_8bit high1_1 (.A(A[32:25]), .B(B[32:25]), .Cin(1'b1), .S(), .Pg(), .Gg(C32));
    
    // Mux correct sums based on predicted carry
    assign S[24:17] = C16 ? S_high1[16:9] : S_high0[16:9];
    assign C32 = C16 ? (G1 | (P1 & 1'b1)) : (G1 | (P1 & 1'b0));
endmodule