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
    
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign S = P ^ C;
endmodule

module csel_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S
);
    wire [7:0] S0, S1;
    wire [3:0] P, G;
    
    // Compute both possible carry scenarios
    cla_4bit lsb0 (.A(A[3:0]), .B(B[3:0]), .Cin(1'b0), .S(S0[3:0]), .Pg(P[0]), .Gg(G[0]));
    cla_4bit lsb1 (.A(A[3:0]), .B(B[3:0]), .Cin(1'b1), .S(S1[3:0]), .Pg(), .Gg());
    
    cla_4bit msb0 (.A(A[7:4]), .B(B[7:4]), .Cin(1'b0), .S(S0[7:4]), .Pg(P[1]), .Gg(G[1]));
    cla_4bit msb1 (.A(A[7:4]), .B(B[7:4]), .Cin(1'b1), .S(S1[7:4]), .Pg(), .Gg());
    
    // Mux based on actual carry-in
    assign S = Cin ? S1 : S0;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [2:0] carry;
    wire [1:0] Pg, Gg;
    
    // Stage 1: 4-bit CLA (bits 1-4)
    cla_4bit block0 (.A(A[4:1]), .B(B[4:1]), .Cin(1'b0), .S(S[4:1]), .Pg(Pg[0]), .Gg(Gg[0]));
    
    // Stage 2: 8-bit carry-select (bits 5-12)
    csel_8bit block1 (.A(A[12:5]), .B(B[12:5]), .Cin(Gg[0] | (Pg[0] & 1'b0)), .S(S[12:5]));
    
    // Stage 3: 8-bit carry-select (bits 13-20)
    wire block1_carry = Gg[0] | (Pg[0] & 1'b0);
    csel_8bit block2 (.A(A[20:13]), .B(B[20:13]), .Cin(block1_carry), .S(S[20:13]));
    
    // Stage 4: 16-bit CLA (bits 21-32)
    wire [15:0] G_stage4 = A[32:17] & B[32:17];
    wire [15:0] P_stage4 = A[32:17] ^ B[32:17];
    wire [15:0] C_stage4;
    
    assign C_stage4[0] = block1_carry;
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : stage4_carry
            assign C_stage4[i] = G_stage4[i-1] | (P_stage4[i-1] & C_stage4[i-1]);
        end
    endgenerate
    
    assign S[32:17] = P_stage4 ^ C_stage4;
    assign C32 = G_stage4[15] | (P_stage4[15] & C_stage4[15]);
endmodule