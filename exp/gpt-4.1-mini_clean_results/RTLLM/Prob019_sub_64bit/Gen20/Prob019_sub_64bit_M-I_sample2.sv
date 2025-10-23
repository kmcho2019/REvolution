module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Internal wires for block-level propagate and generate
    wire [3:0] block_P;
    wire [3:0] block_G;
    wire [4:0] C_block;  // carry signals between blocks (5 bits for 4 blocks + initial carry)

    // Final carry into each 16-bit block
    wire [3:0] carry_in_block;

    // Subtract: A - B = A + (~B) + 1
    wire [63:0] B_neg = ~B;

    // Instantiate four 16-bit CLA adders
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : block_sub
            cla16_subtractor UCLA16 (
                .A     (A[16*i +:16]),
                .B_neg (B_neg[16*i +:16]),
                .Cin   (C_block[i]),
                .Sum   (result[16*i +:16]),
                .P     (block_P[i]),
                .G     (block_G[i])
            );
        end
    endgenerate

    // Initial carry-in to the whole 64-bit subtractor is 1 (for +1 in two's complement subtraction)
    assign C_block[0] = 1'b1;

    // Carry-lookahead logic for block-level carries (4 blocks)
    // C_block[j+1] = G[j] | (P[j] & C_block[j])
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : block_carry_chain
            assign C_block[j+1] = block_G[j] | (block_P[j] & C_block[j]);
        end
    endgenerate

    // Overflow detection: overflow occurs if sign of A and B differ and result sign differs from A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit CLA subtractor block: performs A + B_neg + Cin
// Outputs sum, block propagate P and block generate G for hierarchical CLA
module cla16_subtractor (
    input  wire [15:0] A,
    input  wire [15:0] B_neg,
    input  wire        Cin,
    output wire [15:0] Sum,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);

    wire [15:0] P_bit; // propagate bits
    wire [15:0] G_bit; // generate bits
    wire [16:0] C;     // carries

    assign P_bit = A ^ B_neg;
    assign G_bit = A & B_neg;

    assign C[0] = Cin;

    // Internal carry lookahead for 16 bits
    genvar k;
    generate
        for (k = 0; k < 16; k = k + 1) begin : carry_calc_16
            assign C[k+1] = G_bit[k] | (P_bit[k] & C[k]);
        end
    endgenerate

    assign Sum = P_bit ^ C[15:0];

    // Block propagate = AND of all bit propagates
    assign P = &P_bit;

    // Block generate: any generate inside or propagate all + carry in generate
    // G = G15 + (P15 * G14) + (P15*P14*G13) + ... + (P15*...*P0*Cin)
    // But we only want block generate signal independent of Cin:
    // It can be computed as:
    // G_block = G15 + P15*G14 + P15*P14*G13 + ... + P15*...*P1*G0
    // We implement this with a carry-lookahead style prefix OR-AND

    // Use a generate-propagate prefix to calculate block generate
    wire [15:0] GP_and; // intermediate ANDs for P bits
    assign GP_and[0] = G_bit[0];
    generate
        for (k = 1; k < 16; k = k + 1) begin : gen_blockG
            assign GP_and[k] = G_bit[k] | (P_bit[k] & GP_and[k-1]);
        end
    endgenerate

    assign G = GP_and[15];

endmodule