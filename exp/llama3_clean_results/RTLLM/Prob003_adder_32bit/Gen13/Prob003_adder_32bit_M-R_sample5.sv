// 1-bit Full Adder
module full_adder(
    input A,
    input B,
    input C_in,
    output S,
    output C_out
);

    assign S = A ^ B ^ C_in;
    assign C_out = (A & B) | (A & C_in) | (B & C_in);

endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    wire [16:1] C;

    // Compute carry and sum bits for each bit position
    full_adder u1(
        .A(A[1]),
        .B(B[1]),
        .C_in(C_in),
        .S(S[1]),
        .C_out(C[1])
    );

    generate
        for (genvar i = 2; i <= 16; i++) begin
            full_adder u(
                .A(A[i]),
                .B(B[i]),
                .C_in(C[i-1]),
                .S(S[i]),
                .C_out(C[i])
            );
        end
    endgenerate

    assign C_out = C[16];

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C16;

    // Instantiate two 16-bit adder blocks
    cla_16bit u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16)
    );

    cla_16bit u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16),
        .S(S[32:17]),
        .C_out(C32)
    );

endmodule