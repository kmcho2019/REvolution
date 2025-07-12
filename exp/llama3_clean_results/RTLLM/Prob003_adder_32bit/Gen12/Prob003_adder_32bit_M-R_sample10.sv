// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    // Directly compute carry and sum bits using recursive equations
    assign C_out = (A[16] & B[16]) | ((A[16] ^ B[16]) & (A[15:1] & B[15:1]));
    assign S[16] = A[16] ^ B[16] ^ (A[15:1] & B[15:1]);

    // Compute sum bits using the computed carry bits
    assign S[15:1] = A[15:1] ^ B[15:1] ^ {14{1'b0}, (A[14:1] & B[14:1])};

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C16;

    // Instantiate a single 16-bit adder block
    cla_16bit u1(
       .A(A[16:1]),
       .B(B[16:1]),
       .C_in(1'b0),
       .S(S[16:1]),
       .C_out(C16)
    );

    // Handle carry propagation manually
    assign S[32:17] = A[32:17] ^ B[32:17] ^ {15{C16}};
    assign C32 = (A[32] & B[32]) | ((A[32] ^ B[32]) & C16);

endmodule