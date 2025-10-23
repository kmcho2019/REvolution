module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    // Propagate and Generate signals
    wire [15:0] P = A ^ B;    // propagate
    wire [15:0] G = A & B;    // generate

    // Carry signals
    wire [16:0] C;
    assign C[0] = Cin;

    // Hierarchical carry lookahead
    // Compute carries C[1] to C[16] using the CLA formula:
    // C[i] = G[i-1] | (P[i-1] & C[i-1])
    // Implemented fully with hierarchical structure for clarity

    // First level: carry for each bit
    assign C[1]  = G[0] | (P[0] & C[0]);
    assign C[2]  = G[1] | (P[1] & C[1]);
    assign C[3]  = G[2] | (P[2] & C[2]);
    assign C[4]  = G[3] | (P[3] & C[3]);
    assign C[5]  = G[4] | (P[4] & C[4]);
    assign C[6]  = G[5] | (P[5] & C[5]);
    assign C[7]  = G[6] | (P[6] & C[6]);
    assign C[8]  = G[7] | (P[7] & C[7]);
    assign C[9]  = G[8] | (P[8] & C[8]);
    assign C[10] = G[9] | (P[9] & C[9]);
    assign C[11] = G[10] | (P[10] & C[10]);
    assign C[12] = G[11] | (P[11] & C[11]);
    assign C[13] = G[12] | (P[12] & C[12]);
    assign C[14] = G[13] | (P[13] & C[13]);
    assign C[15] = G[14] | (P[14] & C[14]);
    assign C[16] = G[15] | (P[15] & C[15]);

    // Sum bits
    assign S = P ^ C[15:0];

    assign Cout = C[16];

endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire c16;

    // Remap inputs to zero-based indexing for internal modules
    wire [15:0] A_low  = A[16:1];
    wire [15:0] B_low  = B[16:1];
    wire [15:0] A_high = A[32:17];
    wire [15:0] B_high = B[32:17];

    wire [15:0] S_low;
    wire [15:0] S_high;

    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(c16)
    );

    cla_16bit cla_upper (
        .A(A_high),
        .B(B_high),
        .Cin(c16),
        .S(S_high),
        .Cout(C32)
    );

    // Assign sums back to output in 1-based indexing
    assign S[16:1]  = S_low;
    assign S[32:17] = S_high;

endmodule