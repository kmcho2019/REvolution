// 4-bit Carry-Lookahead Adder
module cla_4bit(A, B, C_in, S, C_out);
    input [3:0] A, B;
    input C_in;
    output [3:0] S;
    output C_out;

    wire [3:1] G, P, C;
    assign G[0] = A[0] & B[0];
    assign P[0] = A[0] | B[0];
    assign S[0] = A[0] ^ B[0] ^ C_in;

    generate
        for (genvar i = 1; i < 4; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
            assign S[i] = A[i] ^ B[i] ^ (C_in + (P[0] & G[1]) + (P[1] & G[2]) + (P[2] & G[3]));
        end
    endgenerate

    assign C_out = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & G[0])))));
endmodule

// 16-bit Carry-Lookahead Adder using 4-bit CLA blocks
module cla_16bit(A, B, C_in, S, C_out);
    input [15:0] A, B;
    input C_in;
    output [15:0] S;
    output C_out;

    wire C4, C8, C12;

    cla_4bit cla_0(A[3:0], B[3:0], C_in, S[3:0], C4);
    cla_4bit cla_1(A[7:4], B[7:4], C4, S[7:4], C8);
    cla_4bit cla_2(A[11:8], B[11:8], C8, S[11:8], C12);
    cla_4bit cla_3(A[15:12], B[15:12], C12, S[15:12], C_out);
endmodule

// Top module: 32-bit Carry-Lookahead Adder
module adder_32bit(A, B, S, C32);
    input [31:0] A, B;
    output [31:0] S;
    output C32;

    wire C16;

    cla_16bit cla_0(A[15:0], B[15:0], 1'b0, S[15:0], C16);
    cla_16bit cla_1(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule