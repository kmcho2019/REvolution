module adder_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Pg,
    output Gg
);
    wire [7:0] P, G;
    wire [8:0] C;
    
    // Generate and Propagate
    assign P = A ^ B;
    assign G = A & B;
    
    // Carry computation using Kogge-Stone parallel prefix
    // First level
    wire [7:0] P1, G1;
    assign {P1[0], G1[0]} = {P[0], G[0]};
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : prefix_level1
            assign P1[i] = P[i] & P[i-1];
            assign G1[i] = G[i] | (P[i] & G[i-1]);
        end
    endgenerate
    
    // Second level
    wire [7:0] P2, G2;
    assign {P2[1:0], G2[1:0]} = {P1[1:0], G1[1:0]};
    generate
        for (i = 2; i < 8; i = i + 1) begin : prefix_level2
            assign P2[i] = P1[i] & P1[i-2];
            assign G2[i] = G1[i] | (P1[i] & G1[i-2]);
        end
    endgenerate
    
    // Third level
    wire [7:0] P3, G3;
    assign {P3[3:0], G3[3:0]} = {P2[3:0], G2[3:0]};
    generate
        for (i = 4; i < 8; i = i + 1) begin : prefix_level3
            assign P3[i] = P2[i] & P2[i-4];
            assign G3[i] = G2[i] | (P2[i] & G2[i-4]);
        end
    endgenerate
    
    // Final carries
    assign C[0] = Cin;
    assign C[1] = G3[0] | (P3[0] & C[0]);
    assign C[2] = G3[1] | (P3[1] & C[0]);
    assign C[3] = G3[2] | (P3[2] & C[0]);
    assign C[4] = G3[3] | (P3[3] & C[0]);
    assign C[5] = G3[4] | (P3[4] & C[0]);
    assign C[6] = G3[5] | (P3[5] & C[0]);
    assign C[7] = G3[6] | (P3[6] & C[0]);
    assign C[8] = G3[7] | (P3[7] & C[0]);
    
    // Sum computation
    assign S = P ^ C[7:0];
    
    // Group propagate and generate
    assign Pg = &P;
    assign Gg = G3[7];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] Pg, Gg;
    wire [4:0] C;
    
    assign C[0] = 1'b0;
    
    // Instantiate four 8-bit CLAs with Kogge-Stone
    adder_8bit cla0 (.A(A[8:1]), .B(B[8:1]), .Cin(C[0]), .S(S[8:1]), .Pg(Pg[0]), .Gg(Gg[0]));
    adder_8bit cla1 (.A(A[16:9]), .B(B[16:9]), .Cin(C[1]), .S(S[16:9]), .Pg(Pg[1]), .Gg(Gg[1]));
    adder_8bit cla2 (.A(A[24:17]), .B(B[24:17]), .Cin(C[2]), .S(S[24:17]), .Pg(Pg[2]), .Gg(Gg[2]));
    adder_8bit cla3 (.A(A[32:25]), .B(B[32:25]), .Cin(C[3]), .S(S[32:25]), .Pg(Pg[3]), .Gg(Gg[3]));
    
    // Carry lookahead logic using parallel prefix
    // First level
    wire [3:0] P1, G1;
    assign {P1[0], G1[0]} = {Pg[0], Gg[0]};
    assign P1[1] = Pg[1] & Pg[0];
    assign G1[1] = Gg[1] | (Pg[1] & Gg[0]);
    assign P1[2] = Pg[2] & Pg[1];
    assign G1[2] = Gg[2] | (Pg[2] & Gg[1]);
    assign P1[3] = Pg[3] & Pg[2];
    assign G1[3] = Gg[3] | (Pg[3] & Gg[2]);
    
    // Second level
    wire [3:0] P2, G2;
    assign {P2[1:0], G2[1:0]} = {P1[1:0], G1[1:0]};
    assign P2[2] = P1[2] & P1[0];
    assign G2[2] = G1[2] | (P1[2] & G1[0]);
    assign P2[3] = P1[3] & P1[1];
    assign G2[3] = G1[3] | (P1[3] & G1[1]);
    
    // Final carries
    assign C[1] = G1[0] | (P1[0] & C[0]);
    assign C[2] = G2[1] | (P2[1] & C[0]);
    assign C[3] = G2[2] | (P2[2] & C[0]);
    assign C[4] = G2[3] | (P2[3] & C[0]);
    
    assign C32 = C[4];
endmodule