// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out,
    output G,  // Generate signal
    output P   // Propagate signal
);

    wire [15:1] C;
    assign G = A[16] & B[16];
    assign P = A[16] | B[16];

    assign C[1] = A[1] & B[1] | (A[1] ^ B[1]) & C_in;
    for (genvar i = 2; i <= 15; i++) begin
        assign C[i] = A[i] & B[i] | (A[i] ^ B[i]) & C[i-1];
    end
    assign C_out = A[16] & B[16] | (A[16] ^ B[16]) & C[15];

    assign S[1] = A[1] ^ B[1] ^ C_in;
    for (genvar i = 2; i <= 16; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end

endmodule

// Predictive Carry Mechanism
module predictive_carry(
    input G1, P1,  // Generate and Propagate from first segment
    input [16:1] A2, B2,  // Inputs for second segment
    output C_in2  // Predicted carry-in for second segment
);

    assign C_in2 = G1 | (P1 & (A2[16] & B2[16]));

endmodule

// 32-bit Hybrid Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C16;
    wire G1, P1;
    wire C_in2;

    // First 16-bit segment
    cla_16bit u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16),
        .G(G1),
        .P(P1)
    );

    // Predictive carry mechanism for second segment
    predictive_carry u2(
        .G1(G1),
        .P1(P1),
        .A2(A[32:17]),
        .B2(B[32:17]),
        .C_in2(C_in2)
    );

    // Second 16-bit segment
    cla_16bit u3(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C_in2),
        .S(S[32:17]),
        .C_out(C32),
        .G(),
        .P()
    );

endmodule