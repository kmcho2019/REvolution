module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Number of 4-bit blocks
    localparam N_BLOCKS = 16;

    // Inter-block carry signals for 4-bit blocks: carry[0] is initial carry-in = 1 for subtraction
    wire [N_BLOCKS:0] carry;
    assign carry[0] = 1'b1;

    // Internal wires for propagate and generate signals from each 4-bit block for higher-level CLA
    wire [N_BLOCKS-1:0] P_block;
    wire [N_BLOCKS-1:0] G_block;

    genvar i;
    generate
        for (i = 0; i < N_BLOCKS; i = i + 1) begin : sub_4bit_blocks
            cla_4bit_sub block4 (
                .A     (A[i*4 +: 4]),
                .B     (B[i*4 +: 4]),
                .cin   (carry[i]),
                .sum   (result[i*4 +: 4]),
                .cout  (),
                .P_out (P_block[i]),
                .G_out (G_block[i])
            );
        end
    endgenerate

    // Higher level carry lookahead generator for 16 blocks to produce carry signals
    carry_lookahead_16 carry_gen_16 (
        .P  (P_block),
        .G  (G_block),
        .cin(carry[0]),
        .C  (carry)
    );

    // Overflow detection for subtraction:
    // Overflow if sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 4-bit CLA Subtractor block performing: sum = A + (~B) + cin
// Provides propagate and generate outputs for hierarchical carry lookahead
module cla_4bit_sub (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout,
    output wire       P_out, // block propagate
    output wire       G_out  // block generate
);
    wire [3:0] B_neg = ~B;

    wire [3:0] P; // bit propagate
    wire [3:0] G; // bit generate
    wire [4:0] C; // carry signals

    assign P = A ^ B_neg;
    assign G = A & B_neg;
    assign C[0] = cin;

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : carry_loop_4bit
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[3:0];
    assign cout = C[4];

    // Block propagate and generate
    // P_out = AND of all bit propagates
    // G_out = G3 | (P3 & G2) | (P3&P2 & G1) | (P3&P2&P1 & G0)
    assign P_out = &P; // all propagate bits must be 1
    assign G_out = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);

endmodule


// 16-bit carry lookahead generator: generate carry signals for 16 blocks
// Inputs:
//   P, G: 16-bit propagate and generate from each 4-bit block
//   cin: initial carry-in
// Outputs:
//   C: 17-bit carry vector, C[0] = cin, C[i+1] = carry out of block i
module carry_lookahead_16 (
    input  wire [15:0] P,
    input  wire [15:0] G,
    input  wire        cin,
    output wire [16:0] C
);
    wire [15:0] C_internal;

    assign C[0] = cin;

    // Generate carry chain:
    // C[i+1] = G[i] | (P[i] & C[i])
    genvar i;
    generate
        for(i = 0; i < 16; i = i + 1) begin : carry_gen_loop
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

endmodule