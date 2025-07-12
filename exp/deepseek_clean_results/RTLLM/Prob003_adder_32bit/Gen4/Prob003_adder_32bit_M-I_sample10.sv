module adder_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Pg,
    output Gg
);
    wire [7:0] P, G;
    wire [8:1] C;
    
    // Generate and Propagate
    assign P = A ^ B;
    assign G = A & B;
    
    // Brent-Kung parallel prefix carry computation
    wire [7:0] G1, P1;
    wire [3:0] G2, P2;
    wire [1:0] G3, P3;
    
    // First level prefix
    assign G1[0] = G[0];
    assign P1[0] = P[0];
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : prefix1
            assign G1[i] = G[i] | (P[i] & G1[i-1]);
            assign P1[i] = P[i] & P1[i-1];
        end
    endgenerate
    
    // Second level prefix (skip every other)
    assign G2[0] = G1[1];
    assign P2[0] = P1[1];
    assign G2[1] = G1[3] | (P1[3] & G1[2]);
    assign P2[1] = P1[3] & P1[2];
    assign G2[2] = G1[5] | (P1[5] & G1[4]);
    assign P2[2] = P1[5] & P1[4];
    assign G2[3] = G1[7] | (P1[7] & G1[6]);
    assign P2[3] = P1[7] & P1[6];
    
    // Final level prefix
    assign G3[0] = G2[1] | (P2[1] & G2[0]);
    assign P3[0] = P2[1] & P2[0];
    assign G3[1] = G2[3] | (P2[3] & G2[2]);
    assign P3[1] = P2[3] & P2[2];
    
    // Carry computation
    assign C[1] = G1[0] | (P1[0] & Cin);
    assign C[2] = G2[0] | (P2[0] & Cin);
    assign C[3] = G1[2] | (P1[2] & C[2]);
    assign C[4] = G3[0] | (P3[0] & Cin);
    assign C[5] = G1[4] | (P1[4] & C[4]);
    assign C[6] = G2[2] | (P2[2] & C[4]);
    assign C[7] = G1[6] | (P1[6] & C[6]);
    assign C[8] = G3[1] | (P3[1] & Cin);
    
    // Sum computation
    assign S = P ^ {C[7:0], Cin};
    
    // Group propagate and generate
    assign Pg = P3[1] & P3[0];
    assign Gg = G3[1] | (P3[1] & G3[0]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] Pg_8bit, Gg_8bit;
    wire [4:0] C;
    
    assign C[0] = 1'b0;
    
    // Instantiate four 8-bit CLAs with Brent-Kung carry lookahead
    adder_8bit cla0 (.A(A[8:1]), .B(B[8:1]), .Cin(C[0]), .S(S[8:1]), .Pg(Pg_8bit[0]), .Gg(Gg_8bit[0]));
    adder_8bit cla1 (.A(A[16:9]), .B(B[16:9]), .Cin(C[1]), .S(S[16:9]), .Pg(Pg_8bit[1]), .Gg(Gg_8bit[1]));
    adder_8bit cla2 (.A(A[24:17]), .B(B[24:17]), .Cin(C[2]), .S(S[24:17]), .Pg(Pg_8bit[2]), .Gg(Gg_8bit[2]));
    adder_8bit cla3 (.A(A[32:25]), .B(B[32:25]), .Cin(C[3]), .S(S[32:25]), .Pg(Pg_8bit[3]), .Gg(Gg_8bit[3]));
    
    // Carry lookahead logic with balanced tree
    wire [1:0] Pg_16bit, Gg_16bit;
    
    // First level (8-bit to 16-bit)
    assign Gg_16bit[0] = Gg_8bit[1] | (Pg_8bit[1] & Gg_8bit[0]);
    assign Pg_16bit[0] = Pg_8bit[1] & Pg_8bit[0];
    assign Gg_16bit[1] = Gg_8bit[3] | (Pg_8bit[3] & Gg_8bit[2]);
    assign Pg_16bit[1] = Pg_8bit[3] & Pg_8bit[2];
    
    // Second level (16-bit to 32-bit)
    wire Gg_32bit = Gg_16bit[1] | (Pg_16bit[1] & Gg_16bit[0]);
    wire Pg_32bit = Pg_16bit[1] & Pg_16bit[0];
    
    // Carry computation
    assign C[1] = Gg_8bit[0] | (Pg_8bit[0] & C[0]);
    assign C[2] = Gg_16bit[0] | (Pg_16bit[0] & C[0]);
    assign C[3] = Gg_8bit[2] | (Pg_8bit[2] & C[2]);
    assign C[4] = Gg_32bit | (Pg_32bit & C[0]);
    
    assign C32 = C[4];
endmodule