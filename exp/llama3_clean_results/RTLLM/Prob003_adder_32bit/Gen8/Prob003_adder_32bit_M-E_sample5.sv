// 4-bit adder block
module adder_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);

    wire [3:1] C;

    assign C[1] = A[1] & B[1] | (A[1] ^ B[1]) & C_in;
    for (genvar i = 2; i <= 3; i++) begin
        assign C[i] = A[i] & B[i] | (A[i] ^ B[i]) & C[i-1];
    end
    assign C_out = A[4] & B[4] | (A[4] ^ B[4]) & C[3];

    assign S[1] = A[1] ^ B[1] ^ C_in;
    for (genvar i = 2; i <= 4; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end

endmodule

// 8-bit adder block
module adder_8bit(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);

    wire [7:1] C;

    assign C[1] = A[1] & B[1] | (A[1] ^ B[1]) & C_in;
    for (genvar i = 2; i <= 7; i++) begin
        assign C[i] = A[i] & B[i] | (A[i] ^ B[i]) & C[i-1];
    end
    assign C_out = A[8] & B[8] | (A[8] ^ B[8]) & C[7];

    assign S[1] = A[1] ^ B[1] ^ C_in;
    for (genvar i = 2; i <= 8; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end

endmodule

// Hybrid Tree Adder (HTA)
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C8, C16, C24;

    // Level 1: 8-bit adder blocks
    adder_8bit u1(
       .A(A[8:1]),
       .B(B[8:1]),
       .C_in(1'b0),
       .S(S[8:1]),
       .C_out(C8)
    );

    adder_8bit u2(
       .A(A[16:9]),
       .B(B[16:9]),
       .C_in(C8),
       .S(S[16:9]),
       .C_out(C16)
    );

    adder_8bit u3(
       .A(A[24:17]),
       .B(B[24:17]),
       .C_in(C16),
       .S(S[24:17]),
       .C_out(C24)
    );

    adder_8bit u4(
       .A(A[32:25]),
       .B(B[32:25]),
       .C_in(C24),
       .S(S[32:25]),
       .C_out(C32)
    );

endmodule