module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    // Efficient 4-bit CLA core with optimized carry generation
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
    output Cout
);
    // Optimized carry chaining with second-level lookahead
    wire [3:0] carry;
    wire [3:0] G_block = {
        (A[15:12] & B[15:12]) != 4'b0,
        (A[11:8] & B[11:8]) != 4'b0,
        (A[7:4] & B[7:4]) != 4'b0,
        (A[3:0] & B[3:0]) != 4'b0
    };
    wire [3:0] P_block = {
        (A[15:12] ^ B[15:12]) == 4'b1111,
        (A[11:8] ^ B[11:8]) == 4'b1111,
        (A[7:4] ^ B[7:4]) == 4'b1111,
        (A[3:0] ^ B[3:0]) == 4'b1111
    };
    
    // Second-level carry lookahead
    assign carry[0] = G_block[0] | (P_block[0] & Cin);
    assign carry[1] = G_block[1] | (P_block[1] & carry[0]);
    assign carry[2] = G_block[2] | (P_block[2] & carry[1]);
    assign Cout = G_block[3] | (P_block[3] & carry[2]);
    
    // Instantiate 4-bit CLAs with pre-computed carries
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), .S(S[7:4]));
    cla_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), .S(S[11:8]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), .S(S[15:12]));
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Hierarchical lookahead between 16-bit blocks
    wire C16;
    wire G_low = (A[16:1] & B[16:1]) != 16'b0;
    wire P_low = (A[16:1] ^ B[16:1]) == 16'b1111_1111_1111_1111;
    wire G_high = (A[32:17] & B[32:17]) != 16'b0;
    wire P_high = (A[32:17] ^ B[32:17]) == 16'b1111_1111_1111_1111;
    
    // Top-level carry lookahead
    assign C16 = G_low | (P_low & 1'b0);
    assign C32 = G_high | (P_high & C16);
    
    // Instantiate 16-bit CLAs with pre-computed carries
    cla_16bit low (.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .S(S[16:1]));
    cla_16bit high (.A(A[32:17]), .B(B[32:17]), .Cin(C16), .S(S[32:17]));
endmodule