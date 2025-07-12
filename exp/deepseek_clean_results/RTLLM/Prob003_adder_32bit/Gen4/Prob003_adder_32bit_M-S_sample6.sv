module CLA_4bit(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Gg
);
    wire [3:0] P, G;
    wire [3:0] C;
    
    // Generate and Propagate
    assign P = A ^ B;
    assign G = A & B;
    
    // Carry calculation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    
    // Sum calculation
    assign S = P ^ C;
    
    // Block generate only (propagate not needed)
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module CLA_16bit(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Gg
);
    wire [3:0] G;
    wire [4:0] C;
    
    assign C[0] = Cin;
    
    CLA_4bit cla0(.A(A[3:0]), .B(B[3:0]), .Cin(C[0]), .S(S[3:0]), .Gg(G[0]));
    CLA_4bit cla1(.A(A[7:4]), .B(B[7:4]), .Cin(C[1]), .S(S[7:4]), .Gg(G[1]));
    CLA_4bit cla2(.A(A[11:8]), .B(B[11:8]), .Cin(C[2]), .S(S[11:8]), .Gg(G[2]));
    CLA_4bit cla3(.A(A[15:12]), .B(B[15:12]), .Cin(C[3]), .S(S[15:12]), .Gg(G[3]));
    
    // Simplified carry lookahead logic
    assign C[1] = G[0] | (A[3:0] ^ B[3:0] == 4'hf) & C[0];
    assign C[2] = G[1] | (A[7:4] ^ B[7:4] == 4'hf) & C[1];
    assign C[3] = G[2] | (A[11:8] ^ B[11:8] == 4'hf) & C[2];
    assign C[4] = G[3] | (A[15:12] ^ B[15:12] == 4'hf) & C[3];
    
    // Block generate only
    assign Gg = G[3] | (A[15:12] ^ B[15:12] == 4'hf) & G[2] | 
               (A[15:8] ^ B[15:8] == 8'hff) & G[1] | 
               (A[15:0] ^ B[15:0] == 16'hffff) & G[0];
endmodule

module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire G0, G1, C16;
    
    CLA_16bit cla0(
        .A(A[16:1]), 
        .B(B[16:1]), 
        .Cin(1'b0), 
        .S(S[16:1]), 
        .Gg(G0)
    );
    
    CLA_16bit cla1(
        .A(A[32:17]), 
        .B(B[32:17]), 
        .Cin(C16), 
        .S(S[32:17]), 
        .Gg(G1)
    );
    
    // Simplified carry calculation
    assign C16 = G0;
    assign C32 = G1 | (A[32:17] ^ B[32:17] == 16'hffff) & C16;
endmodule