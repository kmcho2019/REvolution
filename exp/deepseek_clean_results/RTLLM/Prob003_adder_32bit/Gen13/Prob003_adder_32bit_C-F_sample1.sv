module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);
    
    assign S = P ^ C;
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Pg,
    output Gg
);
    wire [3:0] carry;
    wire [3:0] P_block, G_block;
    
    // Instantiate 4-bit CLAs
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Cout(carry[0]));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), .S(S[7:4]), .Cout(carry[1]));
    cla_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), .S(S[11:8]), .Cout(carry[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), .S(S[15:12]), .Cout(carry[3]));
    
    // Block propagate and generate
    assign P_block[0] = (A[3:0] ^ B[3:0]) == 4'b1111;
    assign G_block[0] = carry[0];
    assign P_block[1] = (A[7:4] ^ B[7:4]) == 4'b1111;
    assign G_block[1] = carry[1];
    assign P_block[2] = (A[11:8] ^ B[11:8]) == 4'b1111;
    assign G_block[2] = carry[2];
    assign P_block[3] = (A[15:12] ^ B[15:12]) == 4'b1111;
    assign G_block[3] = carry[3];
    
    // 16-bit block propagate and generate
    assign Pg = &P_block;
    assign Gg = G_block[3] | (P_block[3] & G_block[2]) | 
                (P_block[3] & P_block[2] & G_block[1]) | 
                (P_block[3] & P_block[2] & P_block[1] & G_block[0]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire P0, G0, P1, G1;
    wire C16;
    
    // Lower 16-bit block
    cla_16bit low (
        .A(A[16:1]), 
        .B(B[16:1]), 
        .Cin(1'b0), 
        .S(S[16:1]), 
        .Pg(P0), 
        .Gg(G0)
    );
    
    // Upper 16-bit block
    cla_16bit high (
        .A(A[32:17]), 
        .B(B[32:17]), 
        .Cin(C16), 
        .S(S[32:17]), 
        .Pg(P1), 
        .Gg(G1)
    );
    
    // Parallel carry computation between 16-bit blocks
    assign C16 = G0 | (P0 & 1'b0);
    assign C32 = G1 | (P1 & G0);
endmodule