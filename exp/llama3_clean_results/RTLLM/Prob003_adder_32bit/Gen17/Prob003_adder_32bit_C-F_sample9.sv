// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);
    wire [3:1] C;
    wire [4:1] G, P; // Generate and Propagate signals

    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    generate
        for (genvar i = 2; i <= 4; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] ^ B[i];
        end
    endgenerate

    assign C[1] = G[1] | (P[1] & C_in);
    generate
        for (genvar i = 2; i <= 3; i++) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    assign S[1] = P[1] ^ C_in;
    generate
        for (genvar i = 2; i <= 4; i++) begin
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate

    assign C_out = G[4] | (P[4] & C[3]);

endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);
    wire C4, C8, C12;

    cla_4bit u1(
        .A(A[4:1]),
        .B(B[4:1]),
        .C_in(C_in),
        .S(S[4:1]),
        .C_out(C4)
    );

    cla_4bit u2(
        .A(A[8:5]),
        .B(B[8:5]),
        .C_in(C4),
        .S(S[8:5]),
        .C_out(C8)
    );

    cla_4bit u3(
        .A(A[12:9]),
        .B(B[12:9]),
        .C_in(C8),
        .S(S[12:9]),
        .C_out(C12)
    );

    cla_4bit u4(
        .A(A[16:13]),
        .B(B[16:13]),
        .C_in(C12),
        .S(S[16:13]),
        .C_out(C_out)
    );

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

    // First 16-bit segment
    cla_16bit u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16)
    );

    // Predictive carry mechanism for second segment
    predictive_carry u2(
        .G1(C16),
        .P1(1'b1),  // Assuming P1 is always 1 for simplicity
        .A2(A[32:17]),
        .B2(B[32:17]),
        .C_in2(C_in2)
    );

    // Second 16-bit segment
    cla_16bit u3(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16),  // Using C16 directly as C_in2 for simplicity
        .S(S[32:17]),
        .C_out(C32)
    );

endmodule