module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Perform A - B as A + (~B) + 1
    wire [63:0] B_neg = ~B;
    wire [63:0] sum;
    wire        carry_out;

    // Hierarchical CLA:
    // Divide into 16 blocks of 4 bits
    wire [15:0] P_block; // Block propagate
    wire [15:0] G_block; // Block generate
    wire [16:0] C_block; // Block carry signals: C_block[0] = cin = 1, carry-ins to blocks

    assign C_block[0] = 1'b1; // initial carry-in for subtraction

    genvar i;
    generate
        for (i = 0; i < 16; i = i +1) begin : four_bit_block
            wire [3:0] A_blk = A[4*i +: 4];
            wire [3:0] B_neg_blk = B_neg[4*i +: 4];
            wire [3:0] sum_blk;
            wire       cout_blk;

            // Within 4-bit block, compute propagate and generate signals for each bit
            wire [3:0] P_bit = A_blk ^ B_neg_blk;       // propagate per bit
            wire [3:0] G_bit = A_blk & B_neg_blk;       // generate per bit
            wire [4:0] C_bit; // carry signals for bits inside block
            assign C_bit[0] = C_block[i]; // carry-in from block-level carry

            // Ripple carry within 4-bit block (low complexity)
            assign C_bit[1] = G_bit[0] | (P_bit[0] & C_bit[0]);
            assign C_bit[2] = G_bit[1] | (P_bit[1] & C_bit[1]);
            assign C_bit[3] = G_bit[2] | (P_bit[2] & C_bit[2]);
            assign C_bit[4] = G_bit[3] | (P_bit[3] & C_bit[3]);
            assign cout_blk = C_bit[4];

            // Compute sum bits
            assign sum_blk = P_bit ^ C_bit[3:0];

            // Compute block propagate and generate signals
            // Block propagate = all bits propagate
            assign P_block[i] = &P_bit;
            // Block generate = generate last bit OR (propagate last bit AND generate third bit) OR ...
            // Equivalent to cout_blk if carry_in=0, but we must calculate explicitly
            // Block generate = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
            assign G_block[i] = G_bit[3] | 
                               (P_bit[3] & G_bit[2]) |
                               (P_bit[3] & P_bit[2] & G_bit[1]) |
                               (P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]);

            // Assign sum bits to output
            assign sum[4*i +: 4] = sum_blk;
        end
    endgenerate

    // Compute carry signals between 4-bit blocks using 16-bit CLA on block propagate/generate
    // C_block[i+1] = G_block[i] + P_block[i]*C_block[i]
    generate
        for (i = 0; i < 16; i = i + 1) begin : block_carry_logic
            assign C_block[i+1] = G_block[i] | (P_block[i] & C_block[i]);
        end
    endgenerate

    assign carry_out = C_block[16];

    assign result = sum;

    // Overflow detection for signed subtraction
    // Overflow occurs if sign(A) != sign(B) and sign(result) != sign(A)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule