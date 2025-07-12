module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Complement of B for two's complement subtraction: ~B + 1
    wire [63:0] B_comp = ~B;

    // Instantiate 64-bit hierarchical CLA adder to perform A + B_comp + 1
    wire cout;
    cla_64bit_hier cla_sub (
        .A   (A),
        .B   (B_comp),
        .cin (1'b1),  // Add 1 to complete two's complement subtraction
        .sum (result),
        .cout(cout)
    );

    // Overflow detection:
    // Overflow occurs if sign of A != sign of B, and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// Hierarchical 64-bit Carry Lookahead Adder (CLA)
// Organized as 8 blocks of 8 bits each:
// - Each 8-bit block generates local P (propagate) and G (generate) signals
// - A top-level 8-bit CLA combines the block-level P and G signals to produce block carry-outs
// This reduces carry chain length from 64 to two levels (8-bit + 8 blocks),
// improving speed compared to flat ripple carry.

module cla_64bit_hier (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);

    wire [63:0] P;  // bit propagate
    wire [63:0] G;  // bit generate

    // Compute per-bit propagate and generate
    assign P = A ^ B;
    assign G = A & B;

    // Divide into 8 blocks of 8 bits
    wire [7:0] block_P; // block propagate signals
    wire [7:0] block_G; // block generate signals
    wire [8:0] carry;   // carry signals for blocks and bits; carry[0] = cin

    assign carry[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : blk
            // Local carries inside each 8-bit block
            wire [7:0] c_local; // internal carries for bits inside block

            // Calculate carries inside 8-bit block using CLA logic
            // c_local[0] = carry_in for block
            // Carry out logic:
            // c[i+1] = G[i] | (P[i] & c[i])

            // We assign c_local[0] to carry for the block from top-level carry array
            assign c_local[0] = carry[i];

            // Compute the internal carries for the 8 bits in this block
            // Flat carry-lookahead inside block (8 bits)
            genvar j;
            for (j = 0; j < 7; j = j + 1) begin : inner_carry
                assign c_local[j+1] = G[i*8 + j] | (P[i*8 + j] & c_local[j]);
            end

            // Sum bits for the 8 bits in this block
            assign sum[i*8 +:8] = P[i*8 +:8] ^ c_local[7:0];

            // Calculate block propagate and generate:
            // block_P = P7 & P6 & ... & P0
            // block_G = G7 | (P7 & G6) | (P7 & P6 & G5) | ... | (P7 & ... & P1 & G0)
            assign block_P[i] = &P[i*8 +:8];

            // block_G calculation via CLA tree inside block:
            // Carry out of block = G7 + (P7 * G6) + (P7*P6*G5) + ... + (P7*...*P0*carry_in)
            // Here, block_G is the carry generate ignoring carry_in,
            // so it equals the carry out of block assuming carry_in = 0
            assign block_G[i] = 
                G[i*8+7] |
                (P[i*8+7] & G[i*8+6]) |
                (P[i*8+7] & P[i*8+6] & G[i*8+5]) |
                (P[i*8+7] & P[i*8+6] & P[i*8+5] & G[i*8+4]) |
                (P[i*8+7] & P[i*8+6] & P[i*8+5] & P[i*8+4] & G[i*8+3]) |
                (P[i*8+7] & P[i*8+6] & P[i*8+5] & P[i*8+4] & P[i*8+3] & G[i*8+2]) |
                (P[i*8+7] & P[i*8+6] & P[i*8+5] & P[i*8+4] & P[i*8+3] & P[i*8+2] & G[i*8+1]) |
                (P[i*8+7] & P[i*8+6] & P[i*8+5] & P[i*8+4] & P[i*8+3] & P[i*8+2] & P[i*8+1] & G[i*8+0]);
        end
    endgenerate

    // Now generate carries between 8-bit blocks using 8-bit CLA logic for block-level P and G
    // carry[k+1] = block_G[k] | (block_P[k] & carry[k])
    genvar b;
    generate
        for (b = 0; b < 8; b = b + 1) begin : block_carry_gen
            assign carry[b+1] = block_G[b] | (block_P[b] & carry[b]);
        end
    endgenerate

    assign cout = carry[8];

endmodule