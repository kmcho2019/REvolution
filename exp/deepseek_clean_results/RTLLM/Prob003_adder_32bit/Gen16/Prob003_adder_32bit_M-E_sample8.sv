module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G,
    output P
);
    wire [3:0] G_bits = A & B;
    wire [3:0] P_bits = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G_bits[0] | (P_bits[0] & C[0]);
    assign C[2] = G_bits[1] | (P_bits[1] & C[1]);
    assign C[3] = G_bits[2] | (P_bits[2] & C[2]);
    
    assign G = G_bits[3] | (P_bits[3] & G_bits[2]) | 
              (P_bits[3] & P_bits[2] & G_bits[1]) | 
              (P_bits[3] & P_bits[2] & P_bits[1] & G_bits[0]);
    assign P = &P_bits;
    assign S = P_bits ^ C;
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output G,
    output P
);
    wire G0, P0, G1, P1;
    wire [3:0] S0, S1;
    wire C4;
    
    // Lower 4 bits
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .G(G0), .P(P0));
    
    // Upper 4 bits with carry-in 0 and 1
    cla_4bit cla1_0 (.A(A[7:4]), .B(B[7:4]), .Cin(1'b0), .S(S0), .G(G1_0), .P(P1_0));
    cla_4bit cla1_1 (.A(A[7:4]), .B(B[7:4]), .Cin(1'b1), .S(S1), .G(G1_1), .P(P1_1));
    
    // Carry select logic
    assign C4 = G0 | (P0 & Cin);
    assign S[7:4] = C4 ? S1 : S0;
    
    // Block generate/propagate
    assign G = G1_1 | (P1_1 & G0);
    assign P = P0 & P1_0;  // P1_0 and P1_1 are same
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] G, P;
    wire [3:0] C;
    
    // First 8-bit segment
    cla_8bit seg0 (.A(A[8:1]), .B(B[8:1]), .Cin(1'b0), .S(S[8:1]), .G(G[0]), .P(P[0]));
    
    // Subsequent segments with carry-select
    cla_8bit seg1_0 (.A(A[16:9]), .B(B[16:9]), .Cin(1'b0), .S(S0_16_9), .G(G1_0), .P(P1_0));
    cla_8bit seg1_1 (.A(A[16:9]), .B(B[16:9]), .Cin(1'b1), .S(S1_16_9), .G(G1_1), .P(P1_1));
    assign C[0] = G[0] | (P[0] & 1'b0);
    assign S[16:9] = C[0] ? S1_16_9 : S0_16_9;
    assign G[1] = G1_1 | (P1_1 & G[0]);
    assign P[1] = P[0] & P1_0;
    
    cla_8bit seg2_0 (.A(A[24:17]), .B(B[24:17]), .Cin(1'b0), .S(S0_24_17), .G(G2_0), .P(P2_0));
    cla_8bit seg2_1 (.A(A[24:17]), .B(B[24:17]), .Cin(1'b1), .S(S1_24_17), .G(G2_1), .P(P2_1));
    assign C[1] = G[1] | (P[1] & C[0]);
    assign S[24:17] = C[1] ? S1_24_17 : S0_24_17;
    assign G[2] = G2_1 | (P2_1 & G[1]);
    assign P[2] = P[1] & P2_0;
    
    cla_8bit seg3_0 (.A(A[32:25]), .B(B[32:25]), .Cin(1'b0), .S(S0_32_25), .G(G3_0), .P(P3_0));
    cla_8bit seg3_1 (.A(A[32:25]), .B(B[32:25]), .Cin(1'b1), .S(S1_32_25), .G(G3_1), .P(P3_1));
    assign C[2] = G[2] | (P[2] & C[1]);
    assign S[32:25] = C[2] ? S1_32_25 : S0_32_25;
    assign G[3] = G3_1 | (P3_1 & G[2]);
    assign P[3] = P[2] & P3_0;
    
    assign C32 = G[3] | (P[3] & C[2]);
endmodule