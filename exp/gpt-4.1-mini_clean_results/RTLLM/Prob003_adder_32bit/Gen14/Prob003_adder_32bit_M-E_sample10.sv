module cla_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       Cin,
    output wire [7:0] S,
    output wire       Cout,
    output wire       P,  // Block propagate
    output wire       G   // Block generate
);

    wire [7:0] P_bit = A ^ B;  // Propagate signals per bit
    wire [7:0] G_bit = A & B;  // Generate signals per bit

    // Compute carries c[0..8], c[0] = Cin
    wire c1 = G_bit[0] | (P_bit[0] & Cin);
    wire c2 = G_bit[1] | (P_bit[1] & c1);
    wire c3 = G_bit[2] | (P_bit[2] & c2);
    wire c4 = G_bit[3] | (P_bit[3] & c3);
    wire c5 = G_bit[4] | (P_bit[4] & c4);
    wire c6 = G_bit[5] | (P_bit[5] & c5);
    wire c7 = G_bit[6] | (P_bit[6] & c6);
    wire c8 = G_bit[7] | (P_bit[7] & c7);

    // Sum bits
    assign S[0] = P_bit[0] ^ Cin;
    assign S[1] = P_bit[1] ^ c1;
    assign S[2] = P_bit[2] ^ c2;
    assign S[3] = P_bit[3] ^ c3;
    assign S[4] = P_bit[4] ^ c4;
    assign S[5] = P_bit[5] ^ c5;
    assign S[6] = P_bit[6] ^ c6;
    assign S[7] = P_bit[7] ^ c7;

    assign Cout = c8;

    // Block propagate: all bits propagate
    assign P = &P_bit;

    // Block generate: G7 + P7*G6 + P7*P6*G5 + ... + P7*...*P0*Cin with Cin=0 = generate of block ignoring Cin
    // Here, block generate = G7 + P7*G6 + P7*P6*G5 + ... + P7*...*P1*G0
    // Compute with zero Cin: internal block generate signal (ignoring Cin)
    // We'll calculate it as c8 when Cin=0:
    wire c1b = G_bit[0] | (P_bit[0] & 1'b0); // = G_bit[0]
    wire c2b = G_bit[1] | (P_bit[1] & c1b);
    wire c3b = G_bit[2] | (P_bit[2] & c2b);
    wire c4b = G_bit[3] | (P_bit[3] & c3b);
    wire c5b = G_bit[4] | (P_bit[4] & c4b);
    wire c6b = G_bit[5] | (P_bit[5] & c5b);
    wire c7b = G_bit[6] | (P_bit[6] & c6b);
    wire c8b = G_bit[7] | (P_bit[7] & c7b);

    assign G = c8b;

endmodule


module cla_4block_carry (
    input  wire [3:0] P_block,
    input  wire [3:0] G_block,
    input  wire       Cin,
    output wire [4:0] C // Carry signals for block boundaries: C[0]=Cin, C[4]=Cout
);

    // Calculate carry signals between blocks
    assign C[0] = Cin;
    assign C[1] = G_block[0] | (P_block[0] & C[0]);
    assign C[2] = G_block[1] | (P_block[1] & C[1]);
    assign C[3] = G_block[2] | (P_block[2] & C[2]);
    assign C[4] = G_block[3] | (P_block[3] & C[3]);

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);

    // Internal zero-based indexing for convenience
    wire [31:0] A_int = {A[32], A[31], A[30], A[29], A[28], A[27], A[26], A[25],
                         A[24], A[23], A[22], A[21], A[20], A[19], A[18], A[17],
                         A[16], A[15], A[14], A[13], A[12], A[11], A[10], A[9],
                         A[8],  A[7],  A[6],  A[5],  A[4],  A[3],  A[2],  A[1]};

    wire [31:0] B_int = {B[32], B[31], B[30], B[29], B[28], B[27], B[26], B[25],
                         B[24], B[23], B[22], B[21], B[20], B[19], B[18], B[17],
                         B[16], B[15], B[14], B[13], B[12], B[11], B[10], B[9],
                         B[8],  B[7],  B[6],  B[5],  B[4],  B[3],  B[2],  B[1]};

    // Split inputs into four 8-bit blocks
    wire [7:0] A_blk0 = A_int[7:0];
    wire [7:0] A_blk1 = A_int[15:8];
    wire [7:0] A_blk2 = A_int[23:16];
    wire [7:0] A_blk3 = A_int[31:24];

    wire [7:0] B_blk0 = B_int[7:0];
    wire [7:0] B_blk1 = B_int[15:8];
    wire [7:0] B_blk2 = B_int[23:16];
    wire [7:0] B_blk3 = B_int[31:24];

    // Sum wires for blocks
    wire [7:0] S_blk0, S_blk1, S_blk2, S_blk3;
    wire       P_blk0, G_blk0;
    wire       P_blk1, G_blk1;
    wire       P_blk2, G_blk2;
    wire       P_blk3, G_blk3;

    // Instantiate 8-bit CLA blocks
    cla_8bit cla0 (.A(A_blk0), .B(B_blk0), .Cin(1'b0),    .S(S_blk0), .Cout(),    .P(P_blk0), .G(G_blk0));
    cla_8bit cla1 (.A(A_blk1), .B(B_blk1), .Cin(),        .S(S_blk1), .Cout(),    .P(P_blk1), .G(G_blk1));
    cla_8bit cla2 (.A(A_blk2), .B(B_blk2), .Cin(),        .S(S_blk2), .Cout(),    .P(P_blk2), .G(G_blk2));
    cla_8bit cla3 (.A(A_blk3), .B(B_blk3), .Cin(),        .S(S_blk3), .Cout(),    .P(P_blk3), .G(G_blk3));

    // Top-level CLA for carry propagation between blocks
    wire [3:0] P_block = {P_blk3, P_blk2, P_blk1, P_blk0};
    wire [3:0] G_block = {G_blk3, G_blk2, G_blk1, G_blk0};
    wire [4:0] C_block;

    cla_4block_carry top_carry (
        .P_block(P_block),
        .G_block(G_block),
        .Cin(1'b0),
        .C(C_block)
    );

    // Connect carry-ins to each 8-bit block (except first which is zero)
    assign cla1.Cin = C_block[1];
    assign cla2.Cin = C_block[2];
    assign cla3.Cin = C_block[3];
    // cla0.Cin is fixed 0 above

    // The final carry out of 32-bit addition
    assign C32 = C_block[4];

    // Concatenate sum blocks back to [32:1]
    assign S = {S_blk3[7], S_blk3[6], S_blk3[5], S_blk3[4], S_blk3[3], S_blk3[2], S_blk3[1], S_blk3[0],
                S_blk2[7], S_blk2[6], S_blk2[5], S_blk2[4], S_blk2[3], S_blk2[2], S_blk2[1], S_blk2[0],
                S_blk1[7], S_blk1[6], S_blk1[5], S_blk1[4], S_blk1[3], S_blk1[2], S_blk1[1], S_blk1[0],
                S_blk0[7], S_blk0[6], S_blk0[5], S_blk0[4], S_blk0[3], S_blk0[2], S_blk0[1], S_blk0[0]};
endmodule