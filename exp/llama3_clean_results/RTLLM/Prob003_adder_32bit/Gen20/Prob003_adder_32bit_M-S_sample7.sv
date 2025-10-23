// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    wire [16:1] P, G;
    wire [15:1] C;

    // Calculate propagate (P) and generate (G) signals
    assign P[1] = A[1] ^ B[1];
    assign G[1] = A[1] & B[1];
    for (genvar i = 2; i <= 16; i++) begin
        assign P[i] = A[i] ^ B[i];
        assign G[i] = A[i] & B[i];
    end

    // Calculate carry signals
    assign C[1] = G[1] | (P[1] & C_in);
    for (genvar i = 2; i <= 15; i++) begin
        assign C[i] = G[i] | (P[i] & C[i-1]);
    end
    assign C_out = G[16] | (P[16] & C[15]);

    // Calculate sum bits
    assign S[1] = P[1] ^ C_in;
    for (genvar i = 2; i <= 16; i++) begin
        assign S[i] = P[i] ^ C[i-1];
    end

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [16:1] S1, S2;
    wire C1;

    // First 16-bit CLA instance for lower 16 bits
    cla_16bit u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S1),
        .C_out(C1)
    );

    // Second 16-bit CLA instance for upper 16 bits
    cla_16bit u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C1),
        .S(S2),
        .C_out(C32)
    );

    // Assign sum bits
    assign S[16:1] = S1;
    assign S[32:17] = S2;

endmodule