// Define a 4-bit carry-lookahead adder block
module cla_4bit(A, B, C_in, S, C_out, G, P);
    input [3:0] A, B;
    input C_in;
    output [3:0] S;
    output C_out;
    output G, P;

    assign G = A[3] & B[3];
    assign P = A[3] | B[3];

    // Calculate the sum (S)
    assign S[0] = A[0] ^ B[0] ^ C_in;
    assign S[1] = A[1] ^ B[1] ^ (A[0] & B[0]);
    assign S[2] = A[2] ^ B[2] ^ (A[1] & B[1]);
    assign S[3] = A[3] ^ B[3] ^ (A[2] & B[2]);

    // Calculate the carry-out (C_out)
    assign C_out = G | (P & C_in);
endmodule

// Define a 16-bit carry-lookahead adder block using the 4-bit CLA block
module cla_16bit(A, B, C_in, S, C_out);
    input [15:0] A, B;
    input C_in;
    output [15:0] S;
    output C_out;

    wire G, P;
    wire [3:0] A_4, B_4, S_4;

    assign A_4 = A[3:0];
    assign B_4 = B[3:0];

    // Calculate the sum (S)
    cla_4bit cla_4bit_inst0(A_4, B_4, C_in, S_4, C_out, G, P);

    assign S[3:0] = S_4;

    // Repeat the process for the remaining bits
    for (genvar i = 1; i < 4; i++) begin
        wire G_i, P_i;
        wire [3:0] A_i, B_i, S_i;

        assign A_i = A[(i * 4) +: 4];
        assign B_i = B[(i * 4) +: 4];

        // Calculate the sum (S)
        cla_4bit cla_4bit_inst(A_i, B_i, C_out, S_i, C_out, G_i, P_i);

        assign S[(i * 4) +: 4] = S_i;
    end
endmodule

// Define the 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;

    wire C16;

    // Use two instances of the 16-bit CLA block
    cla_16bit cla_16bit_inst0(A[16:1], B[16:1], 1'b0, S[16:1], C16);
    cla_16bit cla_16bit_inst1(A[32:17], B[32:17], C16, S[32:17], C32);
endmodule