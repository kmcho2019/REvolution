// 1-bit full adder
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

// 8-bit ripple-carry adder
module rca_8bit(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);

    wire [7:1] C;

    full_adder u1(
        .A(A[1]),
        .B(B[1]),
        .C_in(C_in),
        .S(S[1]),
        .C_out(C[1])
    );

    for (genvar i = 2; i <= 8; i++) begin
        full_adder u2(
            .A(A[i]),
            .B(B[i]),
            .C_in(C[i-1]),
            .S(S[i]),
            .C_out(C[i])
        );
    end

    assign C_out = C[8];

endmodule

// 32-bit hierarchical adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C8, C16, C24;

    // 8-bit RCA block for bits 1-8
    rca_8bit u1(
        .A(A[8:1]),
        .B(B[8:1]),
        .C_in(1'b0),
        .S(S[8:1]),
        .C_out(C8)
    );

    // 8-bit RCA block for bits 9-16
    rca_8bit u2(
        .A(A[16:9]),
        .B(B[16:9]),
        .C_in(C8),
        .S(S[16:9]),
        .C_out(C16)
    );

    // 8-bit RCA block for bits 17-24
    rca_8bit u3(
        .A(A[24:17]),
        .B(B[24:17]),
        .C_in(C16),
        .S(S[24:17]),
        .C_out(C24)
    );

    // 8-bit RCA block for bits 25-32
    rca_8bit u4(
        .A(A[32:25]),
        .B(B[32:25]),
        .C_in(C24),
        .S(S[32:25]),
        .C_out(C32)
    );

endmodule