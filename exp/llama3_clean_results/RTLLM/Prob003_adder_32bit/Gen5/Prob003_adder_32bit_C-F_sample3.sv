// 4-bit Carry-Lookahead Adder with optimized carry generation
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input Cin,
    output [4:1] S,
    output Cout
);
    wire [4:1] G, P;
    wire [3:1] C;

    // Calculate G and P values
    for (genvar i = 1; i <= 4; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    // Calculate C values using efficient logic
    assign C[1] = G[1] | (P[1] & Cin);
    for (genvar i = 2; i <= 3; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end
    assign Cout = G[4] | (P[4] & C[3]);

    // Calculate S values
    assign S[1] = P[1] ^ Cin;
    for (genvar i = 2; i <= 4; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end
endmodule

// 16-bit Carry-Lookahead Adder using optimized 4-bit CLA blocks
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire C4, C8, C12;

    // First 4-bit CLA block
    cla_4bit cla1(
        .A(A[4:1]),
        .B(B[4:1]),
        .Cin(Cin),
        .S(S[4:1]),
        .Cout(C4)
    );

    // Second 4-bit CLA block
    cla_4bit cla2(
        .A(A[8:5]),
        .B(B[8:5]),
        .Cin(C4),
        .S(S[8:5]),
        .Cout(C8)
    );

    // Third 4-bit CLA block
    cla_4bit cla3(
        .A(A[12:9]),
        .B(B[12:9]),
        .Cin(C8),
        .S(S[12:9]),
        .Cout(C12)
    );

    // Fourth 4-bit CLA block
    cla_4bit cla4(
        .A(A[16:13]),
        .B(B[16:13]),
        .Cin(C12),
        .S(S[16:13]),
        .Cout(Cout)
    );
endmodule

// 32-bit Carry-Lookahead Adder using optimized 16-bit CLA blocks
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;

    // Lower 16-bit CLA block
    cla_16bit cla_lower(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    // Upper 16-bit CLA block
    cla_16bit cla_upper(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule