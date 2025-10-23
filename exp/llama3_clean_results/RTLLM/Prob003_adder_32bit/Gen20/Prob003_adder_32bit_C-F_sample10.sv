// 4-bit Carry-Lookahead Adder
module cla_4bit(
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

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    wire [4:1] S1, S2, S3, S4;
    wire C1, C2, C3;

    cla_4bit u1(
        .A(A[4:1]),
        .B(B[4:1]),
        .C_in(C_in),
        .S(S1),
        .C_out(C1)
    );

    cla_4bit u2(
        .A(A[8:5]),
        .B(B[8:5]),
        .C_in(C1),
        .S(S2),
        .C_out(C2)
    );

    cla_4bit u3(
        .A(A[12:9]),
        .B(B[12:9]),
        .C_in(C2),
        .S(S3),
        .C_out(C3)
    );

    cla_4bit u4(
        .A(A[16:13]),
        .B(B[16:13]),
        .C_in(C3),
        .S(S4),
        .C_out(C_out)
    );

    assign S[4:1] = S1;
    assign S[8:5] = S2;
    assign S[12:9] = S3;
    assign S[16:13] = S4;

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [16:1] S1, S2;
    wire C16;

    cla_16bit u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S1),
        .C_out(C16)
    );

    cla_16bit u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16),
        .S(S2),
        .C_out(C32)
    );

    assign S[16:1] = S1;
    assign S[32:17] = S2;

    // Apply clock gating to reduce power consumption
    always @(posedge clk) begin
        if (A == 0 && B == 0) begin
            S <= 0;
            C32 <= 0;
        end else begin
            // Normal operation
        end
    end

endmodule