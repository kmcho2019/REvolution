// Top-level 64-bit subtractor with overflow detection
module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [63:0] B_neg = ~B;   // One's complement of B
    wire        carry_in = 1'b1; // For two's complement addition

    // Internal carry signals between 16-bit blocks
    wire [3:0] block_carry;

    // Split inputs into 16-bit segments
    wire [15:0] A_seg [3:0];
    wire [15:0] B_seg [3:0];
    wire [15:0] sum_seg [3:0];

    assign A_seg[0] = A[15:0];
    assign A_seg[1] = A[31:16];
    assign A_seg[2] = A[47:32];
    assign A_seg[3] = A[63:48];

    assign B_seg[0] = B_neg[15:0];
    assign B_seg[1] = B_neg[31:16];
    assign B_seg[2] = B_neg[47:32];
    assign B_seg[3] = B_neg[63:48];

    // Instantiate four 16-bit CLA blocks
    cla_16bit_block u_cla0 (
        .A   (A_seg[0]),
        .B   (B_seg[0]),
        .cin (carry_in),
        .sum (sum_seg[0]),
        .G   (),           // Block generate (unused here)
        .P   (),           // Block propagate (unused here)
        .cout(block_carry[0])
    );

    cla_16bit_block u_cla1 (
        .A   (A_seg[1]),
        .B   (B_seg[1]),
        .cin (block_carry[0]),
        .sum (sum_seg[1]),
        .G   (),
        .P   (),
        .cout(block_carry[1])
    );

    cla_16bit_block u_cla2 (
        .A   (A_seg[2]),
        .B   (B_seg[2]),
        .cin (block_carry[1]),
        .sum (sum_seg[2]),
        .G   (),
        .P   (),
        .cout(block_carry[2])
    );

    cla_16bit_block u_cla3 (
        .A   (A_seg[3]),
        .B   (B_seg[3]),
        .cin (block_carry[2]),
        .sum (sum_seg[3]),
        .G   (),
        .P   (),
        .cout(block_carry[3])
    );

    assign result = {sum_seg[3], sum_seg[2], sum_seg[1], sum_seg[0]};

    // Overflow detection: 
    // Overflow occurs when the sign bit of A and B differ and sign of result differs from sign of A
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit CLA block for partial sum calculation
// Produces sum, block generate (G), block propagate (P), and cout signals for hierarchy
module cla_16bit_block (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        G,    // block generate
    output wire        P,    // block propagate
    output wire        cout
);
    wire [15:0] P_bits;  // propagate bits
    wire [15:0] G_bits;  // generate bits
    wire [16:0] C;       // carry signals

    assign P_bits = A ^ B;
    assign G_bits = A & B;
    assign C[0] = cin;

    // 4-bit CLA within 16-bit block for speed:
    // Divide 16-bit into four 4-bit sub-blocks
    wire [3:0] P_sub, G_sub;
    wire [4:0] C_sub;

    // Generate per bit carry signals (carry-lookahead within 4-bit groups)
    genvar i;

    // Generate P_sub and G_sub: block propagate and generate for 4-bit chunks
    generate
        for (i = 0; i < 4; i = i + 1) begin : subblock_pg
            assign P_sub[i] = &P_bits[i*4 +: 4]; // AND of 4 propagate bits = block propagate
            assign G_sub[i] = G_bits[i*4 + 3] | 
                             (P_bits[i*4 + 3] & G_bits[i*4 + 2]) |
                             (P_bits[i*4 + 3] & P_bits[i*4 + 2] & G_bits[i*4 + 1]) |
                             (P_bits[i*4 + 3] & P_bits[i*4 + 2] & P_bits[i*4 + 1] & G_bits[i*4]);
        end
    endgenerate

    // Carry lookahead for 4-bit sub-blocks inside the 16-bit block
    assign C_sub[0] = cin;
    assign C_sub[1] = G_sub[0] | (P_sub[0] & C_sub[0]);
    assign C_sub[2] = G_sub[1] | (P_sub[1] & C_sub[1]);
    assign C_sub[3] = G_sub[2] | (P_sub[2] & C_sub[2]);
    assign C_sub[4] = G_sub[3] | (P_sub[3] & C_sub[3]);

    // Generate carry signals for each bit inside each 4-bit sub-block using ripple within small block (acceptable)
    // 4 bits per subblock: carry[bit+1] = g | p & carry[bit]
    generate
        for (i = 0; i < 4; i = i + 1) begin : carry_bits_gen
            wire [3:0] c_local;
            assign c_local[0] = C_sub[i];
            assign c_local[1] = G_bits[i*4] | (P_bits[i*4] & c_local[0]);
            assign c_local[2] = G_bits[i*4+1] | (P_bits[i*4+1] & c_local[1]);
            assign c_local[3] = G_bits[i*4+2] | (P_bits[i*4+2] & c_local[2]);
            assign C[i*4+1]   = c_local[1];
            assign C[i*4+2]   = c_local[2];
            assign C[i*4+3]   = c_local[3];
        end
    endgenerate
    assign C[16] = C_sub[4]; // Carry-out for 16-bit block

    // Calculate sum bits
    assign sum = P_bits ^ C[15:0];

    // Block propagate and generate for the 16-bit block
    assign P = &P_bits;          // propagate = AND of all bit propagates
    assign G = G_sub[3] | (P_sub[3] & G_sub[2]) | (P_sub[3] & P_sub[2] & G_sub[1]) | (P_sub[3] & P_sub[2] & P_sub[1] & G_sub[0]);

    assign cout = C[16];

endmodule