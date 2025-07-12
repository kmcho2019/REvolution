module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Two's complement subtraction: A - B = A + (~B) + 1
    wire [63:0] B_neg = ~B; 
    wire        carry_in = 1'b1;

    wire [63:0] sum;
    wire        cout;

    // Instantiate hierarchical 64-bit CLA: four 16-bit CLA blocks + 4-bit CLA for block carry
    cla_64bit_hier cla64 (
        .A   (A),
        .B   (B_neg),
        .cin (carry_in),
        .sum (sum),
        .cout(cout)
    );

    assign result = sum;

    // Overflow detection for subtraction:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// Hierarchical 64-bit Carry Lookahead Adder (CLA)
// Built from four 16-bit CLA blocks with a 4-bit CLA to generate block carries
module cla_64bit_hier (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);

    wire [3:0] block_cin;
    wire [3:0] block_cout;
    wire [3:0] P_block;
    wire [3:0] G_block;

    assign block_cin[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : cla16_blocks
            cla_16bit cla16 (
                .A   (A[16*i +:16]),
                .B   (B[16*i +:16]),
                .cin (block_cin[i]),
                .sum (sum[16*i +:16]),
                .cout(block_cout[i]),
                .P   (P_block[i]),
                .G   (G_block[i])
            );
        end
    endgenerate

    // 4-bit block CLA to generate carries for each 16-bit block
    cla_4bit_block carry_lookahead (
        .P  (P_block),
        .G  (G_block),
        .cin(cin),
        .C  (block_cin[1:3]),
        .cout(cout)
    );

endmodule


// 16-bit CLA block with outputs for propagate (P) and generate (G) signals for hierarchical carry lookahead
module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);

    wire [15:0] P_bit; // propagate per bit
    wire [15:0] G_bit; // generate per bit
    wire [16:0] C;     // carry signals

    assign C[0] = cin;

    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : bit_cla
            assign P_bit[i] = A[i] ^ B[i];
            assign G_bit[i] = A[i] & B[i];
        end
    endgenerate

    // Carry computation using CLA
    generate
        for (i=0; i<16; i=i+1) begin : carry_gen
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    assign sum = P_bit ^ C[15:0];
    assign cout = C[16];

    // Block propagate: all bits propagate
    assign P = &P_bit;
    // Block generate: either last bit generates or propagate through all preceding bits and cin generates
    assign G = G_bit[15] | (P_bit[15] & G_bit[14]) | 
               (P_bit[15] & P_bit[14] & G_bit[13]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & G_bit[12]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & G_bit[11]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & G_bit[10]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & G_bit[9]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & G_bit[8]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & G_bit[7]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & G_bit[6]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & P_bit[6] & G_bit[5]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & P_bit[6] & P_bit[5] & G_bit[4]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & G_bit[3]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & G_bit[2]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & G_bit[1]) |
               (P_bit[15] & P_bit[14] & P_bit[13] & P_bit[12] & P_bit[11] & P_bit[10] & P_bit[9] & P_bit[8] & P_bit[7] & P_bit[6] & P_bit[5] & P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]);

endmodule


// 4-bit CLA for block-level carry computation
// Inputs:
//  P, G: 4-bit vectors of block propagate and generate signals
//  cin: initial carry in
// Outputs:
//  C[1:3]: carries into blocks 1..3 (block_cin[1..3])
//  cout: carry out of 64-bit adder
module cla_4bit_block (
    input  wire [3:0] P,
    input  wire [3:0] G,
    input  wire       cin,
    output wire [2:0] C,    // carry to blocks 1..3
    output wire       cout  // carry out of entire 64-bit adder
);

    // Carry chain: C[0] = cin implicitly
    assign C[0] = G[0] | (P[0] & cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign cout = G[3] | (P[3] & C[2]);

endmodule