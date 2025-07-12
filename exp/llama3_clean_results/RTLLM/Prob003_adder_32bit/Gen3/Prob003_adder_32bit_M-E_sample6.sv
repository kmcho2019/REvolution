// 8-bit Carry-Lookahead Adder
module cla_8bit(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);

    wire [8:1] G, P;
    wire [7:1] C;

    for (genvar i = 1; i <= 8; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
    end

    assign C[1] = G[1] + (P[1] & C_in);
    for (genvar i = 2; i <= 7; i++) begin
        assign C[i] = G[i] + (P[i] & C[i-1]);
    end
    assign C_out = G[8] + (P[8] & C[7]);

    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= 8; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end

endmodule

// Tree-like Prefix Adder for 4 segments
module prefix_adder_4seg(
    input [3:1] C_in,
    output [3:1] C_out
);

    assign C_out[1] = C_in[1];
    assign C_out[2] = C_in[2] + (C_in[1] & C_in[2]);
    assign C_out[3] = C_in[3] + (C_in[1] & C_in[2] & C_in[3]);

endmodule

// 32-bit Segmented Prefix Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [3:1] C_in, C_out;
    wire [8:1] S1, S2, S3, S4;

    cla_8bit u1(
        .A(A[8:1]),
        .B(B[8:1]),
        .C_in(1'b0),
        .S(S1),
        .C_out(C_in[1])
    );

    cla_8bit u2(
        .A(A[16:9]),
        .B(B[16:9]),
        .C_in(C_in[1]),
        .S(S2),
        .C_out(C_in[2])
    );

    cla_8bit u3(
        .A(A[24:17]),
        .B(B[24:17]),
        .C_in(C_in[2]),
        .S(S3),
        .C_out(C_in[3])
    );

    cla_8bit u4(
        .A(A[32:25]),
        .B(B[32:25]),
        .C_in(C_in[3]),
        .S(S4),
        .C_out(C32)
    );

    prefix_adder_4seg u5(
        .C_in(C_in),
        .C_out(C_out)
    );

    assign S[8:1] = S1;
    assign S[16:9] = S2;
    assign S[24:17] = S3;
    assign S[32:25] = S4;

endmodule