module cla_16bit(
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    // Generate and propagate signals per bit
    wire [15:0] P = A ^ B;
    wire [15:0] G = A & B;

    // Carry signals: C[0] = Cin, C[16] = Cout
    wire [16:0] C;

    assign C[0] = Cin;
    // Explicit carry assignments for clarity and synthesis friendliness
    assign C[1]  = G[0]  | (P[0]  & C[0]);
    assign C[2]  = G[1]  | (P[1]  & C[1]);
    assign C[3]  = G[2]  | (P[2]  & C[2]);
    assign C[4]  = G[3]  | (P[3]  & C[3]);
    assign C[5]  = G[4]  | (P[4]  & C[4]);
    assign C[6]  = G[5]  | (P[5]  & C[5]);
    assign C[7]  = G[6]  | (P[6]  & C[6]);
    assign C[8]  = G[7]  | (P[7]  & C[7]);
    assign C[9]  = G[8]  | (P[8]  & C[8]);
    assign C[10] = G[9]  | (P[9]  & C[9]);
    assign C[11] = G[10] | (P[10] & C[10]);
    assign C[12] = G[11] | (P[11] & C[11]);
    assign C[13] = G[12] | (P[12] & C[12]);
    assign C[14] = G[13] | (P[13] & C[13]);
    assign C[15] = G[14] | (P[14] & C[14]);
    assign C[16] = G[15] | (P[15] & C[15]);

    // Sum bits
    assign S = P ^ C[15:0];

    // Carry-out
    assign Cout = C[16];

endmodule


module adder_32bit(
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire c16;

    // Lower 16-bit CLA block
    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(c16)
    );

    // Upper 16-bit CLA block
    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(c16),
        .S(S[32:17]),
        .Cout(C32)
    );

endmodule