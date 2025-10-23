module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Carry signals between 16-bit blocks (4 blocks)
    wire [4:0] carry16;
    assign carry16[0] = 1'b1; // carry-in = 1 for two's complement subtraction (A + ~B + 1)

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : sub_16blocks
            cla_16bit_sub block16 (
                .A   (A[i*16 +: 16]),
                .B   (B[i*16 +: 16]),
                .cin (carry16[i]),
                .sum (result[i*16 +: 16]),
                .cout(carry16[i+1])
            );
        end
    endgenerate

    // Overflow detection for subtraction:
    // overflow if sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit CLA Subtractor block performing: sum = A + (~B) + cin
// Internally constructed from two 8-bit CLA subtractors with carry-lookahead
module cla_16bit_sub (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,    // carry-in for this block
    output wire [15:0] sum,
    output wire        cout    // carry-out from this block
);

    wire [7:0] sum_low, sum_high;
    wire       c8; // carry between low and high 8-bit blocks

    // Instantiate low 8-bit CLA subtract block
    cla_8bit_sub cla_low (
        .A   (A[7:0]),
        .B   (B[7:0]),
        .cin (cin),
        .sum (sum_low),
        .cout()
    );

    // Instantiate high 8-bit CLA subtract block
    cla_8bit_sub cla_high (
        .A   (A[15:8]),
        .B   (B[15:8]),
        .cin (c8),
        .sum (sum_high),
        .cout()
    );

    // Calculate propagate and generate signals for low and high 8-bit blocks
    wire P_low, G_low, P_high, G_high;

    assign P_low  = & (A[7:0] ^ ~B[7:0]); // Propagate = AND of all P bits in low byte
    assign G_low  = | (A[7:0] & ~B[7:0]); // Generate = OR of all G bits in low byte
    // This rough approximation won't work for precise carry lookahead, so replace with proper block propagate/generate

    // Better approach: replicate block propagate/generate signals from cla_8bit_sub inside

    // To correctly compute carry c8, replicate cla_8bit_sub propagate and generate signals here:

    wire [7:0] P_low_bits, G_low_bits;
    wire [7:0] P_high_bits, G_high_bits;

    // Define propagate and generate bits for low 8 bits
    assign P_low_bits = A[7:0] ^ ~B[7:0];
    assign G_low_bits = A[7:0] & ~B[7:0];

    // Carry lookahead for c8 = G_low[7] + (P_low[7] * cin)
    wire c1,c2,c3,c4,c5,c6,c7;
    assign c1 = G_low_bits[0] | (P_low_bits[0] & cin);
    assign c2 = G_low_bits[1] | (P_low_bits[1] & c1);
    assign c3 = G_low_bits[2] | (P_low_bits[2] & c2);
    assign c4 = G_low_bits[3] | (P_low_bits[3] & c3);
    assign c5 = G_low_bits[4] | (P_low_bits[4] & c4);
    assign c6 = G_low_bits[5] | (P_low_bits[5] & c5);
    assign c7 = G_low_bits[6] | (P_low_bits[6] & c6);
    assign c8 = G_low_bits[7] | (P_low_bits[7] & c7);

    // Similarly for high block propagate and generate signals (for cout)
    assign P_high_bits = A[15:8] ^ ~B[15:8];
    assign G_high_bits = A[15:8] & ~B[15:8];

    // Carry lookahead for cout = G_high[7] + (P_high[7] * c8)
    wire c9,c10,c11,c12,c13,c14,c15;
    wire cout_tmp;
    assign c9  = G_high_bits[0] | (P_high_bits[0] & c8);
    assign c10 = G_high_bits[1] | (P_high_bits[1] & c9);
    assign c11 = G_high_bits[2] | (P_high_bits[2] & c10);
    assign c12 = G_high_bits[3] | (P_high_bits[3] & c11);
    assign c13 = G_high_bits[4] | (P_high_bits[4] & c12);
    assign c14 = G_high_bits[5] | (P_high_bits[5] & c13);
    assign c15 = G_high_bits[6] | (P_high_bits[6] & c14);
    assign cout = G_high_bits[7] | (P_high_bits[7] & c15);

    assign sum = {sum_high, sum_low};
endmodule


// 8-bit CLA Subtractor block performing: sum = A + (~B) + cin
module cla_8bit_sub (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] B_neg = ~B;

    wire [7:0] P; // propagate signals
    wire [7:0] G; // generate signals
    wire [8:0] C; // carry signals

    assign P = A ^ B_neg;
    assign G = A & B_neg;
    assign C[0] = cin;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : carry_loop
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[7:0];
    assign cout = C[8];
endmodule