module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout,
    output G,
    output P
);
    wire [3:0] G_bit = A & B;
    wire [3:0] P_bit = A ^ B;
    
    wire C1 = G_bit[0] | (P_bit[0] & Cin);
    wire C2 = G_bit[1] | (P_bit[1] & C1);
    wire C3 = G_bit[2] | (P_bit[2] & C2);
    
    assign S = P_bit ^ {C3, C2, C1, Cin};
    assign Cout = G_bit[3] | (P_bit[3] & C3);
    assign G = G_bit[3] | (G_bit[2] & P_bit[3]) | (G_bit[1] & P_bit[2] & P_bit[3]) | 
               (G_bit[0] & P_bit[1] & P_bit[2] & P_bit[3]);
    assign P = &P_bit;
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout,
    output G,
    output P
);
    wire [1:0] carry;
    wire [1:0] G_block;
    wire [1:0] P_block;
    
    cla_4bit cla0 (A[3:0], B[3:0], Cin, S[3:0], carry[0], G_block[0], P_block[0]);
    cla_4bit cla1 (A[7:4], B[7:4], carry[0], S[7:4], carry[1], G_block[1], P_block[1]);
    
    assign G = G_block[1] | (G_block[0] & P_block[1]);
    assign P = P_block[0] & P_block[1];
    assign Cout = G | (P & Cin);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    wire [3:0] G_block;
    wire [3:0] P_block;
    
    // First level lookahead
    cla_8bit block0 (A[8:1], B[8:1], 1'b0, S[8:1], carry[0], G_block[0], P_block[0]);
    cla_8bit block1 (A[16:9], B[16:9], carry[0], S[16:9], carry[1], G_block[1], P_block[1]);
    cla_8bit block2 (A[24:17], B[24:17], carry[1], S[24:17], carry[2], G_block[2], P_block[2]);
    cla_8bit block3 (A[32:25], B[32:25], carry[2], S[32:25], carry[3], G_block[3], P_block[3]);
    
    // Second level lookahead
    wire C8 = G_block[0] | (P_block[0] & 1'b0);
    wire C16 = G_block[1] | (P_block[1] & C8);
    wire C24 = G_block[2] | (P_block[2] & C16);
    
    assign C32 = G_block[3] | (P_block[3] & C24);
endmodule