module cla_4bit_opt (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    // Parallel prefix computation for carries
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    // First level carry computation
    wire G01 = G[0] | (P[0] & G[1]);
    wire P01 = P[0] & P[1];
    wire G23 = G[2] | (P[2] & G[3]);
    wire P23 = P[2] & P[3];
    
    // Second level carry computation
    wire G03 = G01 | (P01 & G23);
    wire P03 = P01 & P23;
    
    // Final carries
    wire C1 = G[0] | (P[0] & Cin);
    wire C2 = G[1] | (P[1] & C1);
    wire C3 = G[2] | (P[2] & C2);
    wire C4 = G[3] | (P[3] & C3);
    
    assign Cout = G03 | (P03 & Cin);
    assign S = P ^ {C3, C2, C1, Cin};
endmodule

module cla_16bit_opt (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] carry;
    wire [3:0] G_block, P_block;
    
    // Generate block-level PG signals
    cla_4bit_opt cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), 
                 .S(S[3:0]), .Cout(carry[0]));
    assign G_block[0] = (A[3:0] & B[3:0]) != 0;
    assign P_block[0] = (A[3:0] ^ B[3:0]) == 4'b1111;
    
    cla_4bit_opt cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), 
                 .S(S[7:4]), .Cout(carry[1]));
    assign G_block[1] = (A[7:4] & B[7:4]) != 0;
    assign P_block[1] = (A[7:4] ^ B[7:4]) == 4'b1111;
    
    cla_4bit_opt cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), 
                 .S(S[11:8]), .Cout(carry[2]));
    assign G_block[2] = (A[11:8] & B[11:8]) != 0;
    assign P_block[2] = (A[11:8] ^ B[11:8]) == 4'b1111;
    
    cla_4bit_opt cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), 
                 .S(S[15:12]), .Cout(carry[3]));
    assign G_block[3] = (A[15:12] & B[15:12]) != 0;
    assign P_block[3] = (A[15:12] ^ B[15:12]) == 4'b1111;
    
    // Block-level carry lookahead
    assign Cout = carry[3];
endmodule

module adder_32bit (
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C32
);
    wire C16;
    
    cla_16bit_opt low (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(C16)
    );
    
    cla_16bit_opt high (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule