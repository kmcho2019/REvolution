module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Invert B for two's complement subtraction
    wire [63:0] B_comp = ~B;

    // Perform A + (~B) + 1 using a single 64-bit CLA adder
    wire        carry_out;

    cla_64bit cla64 (
        .A   (A),
        .B   (B_comp),
        .cin (1'b1),
        .sum (result),
        .cout(carry_out)
    );

    // Overflow detection:
    // Overflow if sign of A and B differ and result sign differs from A's sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 64-bit Carry Lookahead Adder built from 4 x 16-bit CLA blocks with hierarchical carry
module cla_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    wire [3:0] block_P;  // Block propagate signals
    wire [3:0] block_G;  // Block generate signals
    wire [4:0] carry;    // Carry signals between blocks (carry[0] = cin)

    assign carry[0] = cin;

    // Instantiate four 16-bit CLA blocks
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : cla16_blocks
            cla_16bit cla16_inst (
                .A    (A[16*i +: 16]),
                .B    (B[16*i +: 16]),
                .cin  (carry[i]),
                .sum  (sum[16*i +: 16]),
                .cout (/* unused here */),
                .Pout (block_P[i]),
                .Gout (block_G[i])
            );
        end
    endgenerate

    // Hierarchical carry computation between 16-bit blocks:
    // carry[i+1] = G[i] | (P[i] & carry[i])
    assign carry[1] = block_G[0] | (block_P[0] & carry[0]);
    assign carry[2] = block_G[1] | (block_P[1] & carry[1]);
    assign carry[3] = block_G[2] | (block_P[2] & carry[2]);
    assign carry[4] = block_G[3] | (block_P[3] & carry[3]);

    assign cout = carry[4];

endmodule


// 16-bit Carry Lookahead Adder with block propagate/generate outputs
module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        cout,
    output wire        Pout,  // block propagate
    output wire        Gout   // block generate
);
    wire [15:0] P;  // propagate per bit
    wire [15:0] G;  // generate per bit
    wire [16:0] C;  // carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = cin;

    // Generate carry signals for bits [1..16]
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : carry_gen_16
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[15:0];
    assign cout = C[16];

    // Block propagate is AND of all P bits
    assign Pout = &P;

    // Block generate logic:
    // Gout = G15 + P15*G14 + P15*P14*G13 + ... + P15*...*P0*cin
    // Using hierarchical computation:
    wire g0 = G[0];
    wire g1 = G[1] | (P[1] & g0);
    wire g2 = G[2] | (P[2] & g1);
    wire g3 = G[3] | (P[3] & g2);
    wire g4 = G[4] | (P[4] & g3);
    wire g5 = G[5] | (P[5] & g4);
    wire g6 = G[6] | (P[6] & g5);
    wire g7 = G[7] | (P[7] & g6);
    wire g8 = G[8] | (P[8] & g7);
    wire g9 = G[9] | (P[9] & g8);
    wire g10 = G[10] | (P[10] & g9);
    wire g11 = G[11] | (P[11] & g10);
    wire g12 = G[12] | (P[12] & g11);
    wire g13 = G[13] | (P[13] & g12);
    wire g14 = G[14] | (P[14] & g13);
    wire g15 = G[15] | (P[15] & g14);

    assign Gout = g15 | (Pout & cin);

endmodule