// Define the 16-bit CLA block
module cla_16bit(A, B, C_in, S, C_out);
    input [15:0] A, B;
    input C_in;
    output [15:0] S;
    output C_out;

    wire [15:0] G, P; // Generate and Propagate signals
    wire [15:0] C; // Internal carry signals

    // Calculate Generate and Propagate signals
    assign G = A & B;
    assign P = A | B;

    // Calculate internal carry signals
    assign C[0] = G[0] | (P[0] & C_in);
    assign C[1] = G[1] | (P[1] & (G[0] | (P[0] & C_in)));
    assign C[2] = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))));
    assign C[3] = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in))))));
    assign C[4] = G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in))))))));
    assign C[5] = G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))))))));
    assign C[6] = G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in))))))))));
    assign C[7] = G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in))))))))));
    assign C[8] = G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))))))))));
    assign C[9] = G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))))))))));
    assign C[10] = G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))))))))));
    assign C[11] = G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))))))))));
    assign C[12] = G[12] | (P[12] & (G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))))))))));
    assign C[13] = G[13] | (P[13] & (G[12] | (P[12] & (G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))))))))));
    assign C[14] = G[14] | (P[14] & (G[13] | (P[13] & (G[12] | (P[12] & (G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))))))))));
    assign C[15] = G[15] | (P[15] & (G[14] | (P[14] & (G[13] | (P[13] & (G[12] | (P[12] & (G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))))))))));

    // Calculate sum
    assign S[0] = A[0] ^ B[0] ^ C_in;
    assign S[1] = A[1] ^ B[1] ^ C[0];
    assign S[2] = A[2] ^ B[2] ^ C[1];
    assign S[3] = A[3] ^ B[3] ^ C[2];
    assign S[4] = A[4] ^ B[4] ^ C[3];
    assign S[5] = A[5] ^ B[5] ^ C[4];
    assign S[6] = A[6] ^ B[6] ^ C[5];
    assign S[7] = A[7] ^ B[7] ^ C[6];
    assign S[8] = A[8] ^ B[8] ^ C[7];
    assign S[9] = A[9] ^ B[9] ^ C[8];
    assign S[10] = A[10] ^ B[10] ^ C[9];
    assign S[11] = A[11] ^ B[11] ^ C[10];
    assign S[12] = A[12] ^ B[12] ^ C[11];
    assign S[13] = A[13] ^ B[13] ^ C[12];
    assign S[14] = A[14] ^ B[14] ^ C[13];
    assign S[15] = A[15] ^ B[15] ^ C[14];

    // Calculate final carry-out
    assign C_out = G[15] | (P[15] & (G[14] | (P[14] & (G[13] | (P[13] & (G[12] | (P[12] & (G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & C_in)))))))))))))));

endmodule

// Top module: 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;

    wire C16; // Carry from lower 16 bits to upper 16 bits

    // Lower 16 bits addition
    cla_16bit lower_bits_add(A[16:1], B[16:1], 1'b0, S[16:1], C16);

    // Upper 16 bits addition
    cla_16bit upper_bits_add(A[31:17], B[31:17], C16, S[31:17], C32);

endmodule