module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        Pout,
    output        Gout
);
    wire [16:1] P;  // propagate bits
    wire [16:1] G;  // generate bits
    wire [16:0] C;  // carry bits, C[0] = Cin

    assign C[0] = Cin;

    // Generate and propagate for each bit
    genvar i;
    generate
        for (i=1; i<=16; i=i+1) begin : gen_prop
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // Carry lookahead logic for 16 bits
    // Carry[i] = G[i] + P[i]*Carry[i-1]
    // We compute carries from C[1] to C[16]
    // For fast calculation, we use carry-lookahead equations:
    // C[1] = G[1] + P[1]*C[0]
    // C[2] = G[2] + P[2]*G[1] + P[2]*P[1]*C[0]
    // ...
    // C[16] similarly

    // Implementing using generate statement with full carry calculation
    wire c1, c2, c3, c4, c5, c6, c7, c8;
    wire c9, c10, c11, c12, c13, c14, c15, c16;

    // To optimize, we can generate group propagate and generate signals for 4-bit blocks,
    // but since only 16 bits, we can implement straightforwardly using recursive carry

    assign C[1]  = G[1]  | (P[1]  & C[0]);
    assign C[2]  = G[2]  | (P[2]  & G[1])  | (P[2] & P[1]  & C[0]);
    assign C[3]  = G[3]  | (P[3]  & G[2])  | (P[3] & P[2]  & G[1])  | (P[3] & P[2] & P[1] & C[0]);
    assign C[4]  = G[4]  | (P[4]  & G[3])  | (P[4] & P[3]  & G[2])  | (P[4] & P[3] & P[2] & G[1]) | (P[4]&P[3]&P[2]&P[1]&C[0]);
    assign C[5]  = G[5]  | (P[5]  & G[4])  | (P[5] & P[4]  & G[3])  | (P[5] & P[4] & P[3] & G[2]) | (P[5]&P[4]&P[3]&P[2]&G[1]) | (P[5]&P[4]&P[3]&P[2]&P[1]&C[0]);
    assign C[6]  = G[6]  | (P[6]  & G[5])  | (P[6] & P[5]  & G[4])  | (P[6] & P[5] & P[4] & G[3]) | (P[6]&P[5]&P[4]&P[3]&G[2]) | (P[6]&P[5]&P[4]&P[3]&P[2]&G[1]) | (P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&C[0]);
    assign C[7]  = G[7]  | (P[7]  & G[6])  | (P[7] & P[6]  & G[5])  | (P[7] & P[6] & P[5] & G[4]) | (P[7]&P[6]&P[5]&P[4]&G[3]) | (P[7]&P[6]&P[5]&P[4]&P[3]&G[2]) | (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&G[1]) | (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&C[0]);
    assign C[8]  = G[8]  | (P[8]  & G[7])  | (P[8] & P[7]  & G[6])  | (P[8] & P[7] & P[6] & G[5]) | (P[8]&P[7]&P[6]&P[5]&G[4]) | (P[8]&P[7]&P[6]&P[5]&P[4]&G[3]) | (P[8]&P[7]&P[6]&P[5]&P[4]&P[3]&G[2]) | (P[8]&P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&G[1]) | (P[8]&P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&C[0]);

    assign C[9]  = G[9]  | (P[9]  & C[8]);
    assign C[10] = G[10] | (P[10] & G[9])  | (P[10] & P[9]  & C[8]);
    assign C[11] = G[11] | (P[11] & G[10]) | (P[11] & P[10] & G[9])  | (P[11] & P[10] & P[9]  & C[8]);
    assign C[12] = G[12] | (P[12] & G[11]) | (P[12] & P[11] & G[10]) | (P[12] & P[11] & P[10] & G[9]) | (P[12] & P[11] & P[10] & P[9]  & C[8]);
    assign C[13] = G[13] | (P[13] & G[12]) | (P[13] & P[12] & G[11]) | (P[13] & P[12] & P[11] & G[10]) | (P[13] & P[12] & P[11] & P[10] & G[9]) | (P[13] & P[12] & P[11] & P[10] & P[9]  & C[8]);
    assign C[14] = G[14] | (P[14] & G[13]) | (P[14] & P[13] & G[12]) | (P[14] & P[13] & P[12] & G[11]) | (P[14] & P[13] & P[12] & P[11] & G[10]) | (P[14] & P[13] & P[12] & P[11] & P[10] & G[9]) | (P[14] & P[13] & P[12] & P[11] & P[10] & P[9]  & C[8]);
    assign C[15] = G[15] | (P[15] & G[14]) | (P[15] & P[14] & G[13]) | (P[15] & P[14] & P[13] & G[12]) | (P[15] & P[14] & P[13] & P[12] & G[11]) | (P[15] & P[14] & P[13] & P[12] & P[11] & G[10]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & G[9]) | (P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9]  & C[8]);
    assign C[16] = G[16] | (P[16] & G[15]) | (P[16] & P[15] & G[14]) | (P[16] & P[15] & P[14] & G[13]) | (P[16] & P[15] & P[14] & P[13] & G[12]) | (P[16] & P[15] & P[14] & P[13] & P[12] & G[11]) | (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & G[10]) | (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & G[9]) | (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9]  & C[8]);

    // Calculate output sum bits
    assign S = P ^ C[15:0];

    // Compute group propagate and generate for the 16-bit block
    // Pout = P[16:1] all ANDed
    assign Pout = &P[16:1];
    // Gout = G[16] or (P[16] & G[15]) or (P[16]*P[15]*G[14]) ... or (P[16]*...*P[1]*Cin)
    // We use the carry out C[16], and since carry[0] = Cin,
    // Gout can be computed as C[16] without Cin part for group generate.
    // But to follow formal definition:
    assign Gout = G[16] | (P[16] & G[15]) | (P[16] & P[15] & G[14]) | (P[16] & P[15] & P[14] & G[13]) |
                  (P[16] & P[15] & P[14] & P[13] & G[12]) | (P[16] & P[15] & P[14] & P[13] & P[12] & G[11]) |
                  (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & G[10]) | (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & G[9]) |
                  (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & G[8]) |
                  (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & G[7]) |
                  (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & G[6]) |
                  (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & G[5]) |
                  (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & G[4]) |
                  (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & P[4] & G[3]) |
                  (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) |
                  (P[16] & P[15] & P[14] & P[13] & P[12] & P[11] & P[10] & P[9] & P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]);

    assign Cout = C[16];

endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);

    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Instantiate lower 16 bits CLA
    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .Pout(P_low),
        .Gout(G_low)
    );

    // Instantiate upper 16 bits CLA
    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32),
        .Pout(P_high),
        .Gout(G_high)
    );

endmodule