// 1-bit Full Adder
module full_adder(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);

    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);

endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);

    wire [15:1] C;

    // Calculate carry and sum bits
    full_adder u1(
        .A(A[1]),
        .B(B[1]),
        .Cin(Cin),
        .S(S[1]),
        .Cout(C[1])
    );

    generate
        for (genvar i = 2; i <= 16; i++) begin
            full_adder u2(
                .A(A[i]),
                .B(B[i]),
                .Cin(C[i-1]),
                .S(S[i]),
                .Cout(C[i])
            );
        end
    endgenerate

    assign Cout = C[16];

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
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    cla_16bit u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );

endmodule