// Pre-computation stage
module pre_computation(
    input [32:1] A,
    input [32:1] B,
    output [32:1] G,
    output [32:1] P
);

    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];

    for (genvar i = 2; i <= 32; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end

endmodule

// Ripple-carry adder (RCA) stage
module rca_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    wire [15:1] C;

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

// Carry-lookahead adder (CLA) stage
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    wire [15:1] C;

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

// Sum and carry computation stage
module sum_carry_computation(
    input [32:1] G,
    input [32:1] P,
    input C_in,
    output [32:1] S,
    output C_out
);

    wire [31:1] C;

    assign C[1] = G[1] | (P[1] & C_in);
    for (genvar i = 2; i <= 31; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end
    assign C_out = G[32] | (P[32] & C[31]);

    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= 32; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end

endmodule

// 32-bit carry-lookahead adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [32:1] G, P;
    wire [16:1] S_rca, S_cla;
    wire C_rca, C_cla;

    pre_computation u1(
       .A(A),
       .B(B),
       .G(G),
       .P(P)
    );

    rca_16bit u2(
       .A(A[16:1]),
       .B(B[16:1]),
       .C_in(1'b0),
       .S(S_rca),
       .C_out(C_rca)
    );

    cla_16bit u3(
       .A(A[32:17]),
       .B(B[32:17]),
       .C_in(C_rca),
       .S(S_cla),
       .C_out(C_cla)
    );

    sum_carry_computation u4(
       .G(G),
       .P(P),
       .C_in(1'b0),
       .S(S),
       .C_out(C32)
    );

    assign S[16:1] = S_rca;
    assign S[32:17] = S_cla;

endmodule