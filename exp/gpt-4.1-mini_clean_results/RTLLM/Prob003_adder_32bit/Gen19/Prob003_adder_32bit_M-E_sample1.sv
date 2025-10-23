module cla_8bit (
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    input  wire        Cin,
    output wire [7:0]  S,
    output wire        Cout,
    output wire        P_block,
    output wire        G_block
);
    // Generate and propagate signals per bit
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;

    // Compute carry signals explicitly using CLA equations:
    // c0 = Cin
    // c1 = G0 + P0 * Cin
    // c2 = G1 + P1*G0 + P1*P0*Cin
    // c3 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*Cin
    // ...
    wire c0 = Cin;
    wire c1 = G[0] | (P[0] & c0);
    wire c2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & c0);
    wire c3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & c0);
    wire c4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & c0);
    wire c5 = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & G[0]) | (P[4] & P[3] & P[2] & P[1] & P[0] & c0);
    wire c6 = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & c0);
    wire c7 = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & c0);
    wire c8 = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & c0);

    // Sum bits
    assign S = P ^ {c7,c6,c5,c4,c3,c2,c1,c0};

    // Block propagate: all bits propagate
    assign P_block = &P;

    // Block generate: carry out with carry-in = 0
    // Using c8 with c0=0 means only generate terms remain
    // So G_block = G[7] + P[7]*G[6] + ... + P[7]*...*P[0]*0 = carry out with Cin=0
    // Let's compute block generate accordingly:
    wire G0 = G[0];
    wire G1 = G[1] | (P[1] & G[0]);
    wire G2 = G[2] | (P[2] & G1);
    wire G3 = G[3] | (P[3] & G2);
    wire G4 = G[4] | (P[4] & G3);
    wire G5 = G[5] | (P[5] & G4);
    wire G6 = G[6] | (P[6] & G5);
    wire G7 = G[7] | (P[7] & G6);

    assign G_block = G7;

    assign Cout = c8;

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based signals for easier slicing
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin : input_remap
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    // Break inputs into 4 segments of 8 bits each
    wire [7:0] A0 = A_int[7:0];
    wire [7:0] A1 = A_int[15:8];
    wire [7:0] A2 = A_int[23:16];
    wire [7:0] A3 = A_int[31:24];

    wire [7:0] B0 = B_int[7:0];
    wire [7:0] B1 = B_int[15:8];
    wire [7:0] B2 = B_int[23:16];
    wire [7:0] B3 = B_int[31:24];

    // Outputs from each CLA block
    wire [7:0] S0, S1, S2, S3;
    wire C8, C16, C24;

    wire P0, G0;
    wire P1, G1;
    wire P2, G2;
    wire P3, G3;

    // Carry-in for first block is zero
    wire C0 = 1'b0;

    // Compute carry-ins for following blocks using block propagate and generate
    // Carry-in to block 1 (bits 9-16)
    wire C8_internal = G0 | (P0 & C0);
    // Carry-in to block 2 (bits 17-24)
    wire C16_internal = G1 | (P1 & C8_internal);
    // Carry-in to block 3 (bits 25-32)
    wire C24_internal = G2 | (P2 & C16_internal);

    // Instantiate 8-bit CLA blocks
    cla_8bit cla0 (.A(A0), .B(B0), .Cin(C0),        .S(S0), .Cout(C8),  .P_block(P0), .G_block(G0));
    cla_8bit cla1 (.A(A1), .B(B1), .Cin(C8_internal), .S(S1), .Cout(C16), .P_block(P1), .G_block(G1));
    cla_8bit cla2 (.A(A2), .B(B2), .Cin(C16_internal),.S(S2), .Cout(C24), .P_block(P2), .G_block(G2));
    cla_8bit cla3 (.A(A3), .B(B3), .Cin(C24_internal),.S(S3), .Cout(C32), .P_block(P3), .G_block(G3));

    // Map sums back to [32:1] output
    generate
        for (i=0; i<8; i=i+1) begin : sum_block0
            assign S[i+1] = S0[i];
        end
        for (i=0; i<8; i=i+1) begin : sum_block1
            assign S[i+9] = S1[i];
        end
        for (i=0; i<8; i=i+1) begin : sum_block2
            assign S[i+17] = S2[i];
        end
        for (i=0; i<8; i=i+1) begin : sum_block3
            assign S[i+25] = S3[i];
        end
    endgenerate

endmodule