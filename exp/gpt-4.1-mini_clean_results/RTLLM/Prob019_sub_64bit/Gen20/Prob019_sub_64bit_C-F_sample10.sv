module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Two's complement subtraction: A - B = A + (~B) + 1
    wire [63:0] B_neg = ~B;

    // Divide inputs into eight 8-bit blocks
    wire [7:0] A_blocks [7:0];
    wire [7:0] B_blocks [7:0];
    wire [7:0] sum_blocks [7:0];
    wire       c_in_blocks [8:0];   // carries into blocks, 9 total (including initial and final)
    wire       c_out_blocks [7:0];  // carry out from each 8-bit block
    wire [7:0] p_blocks; // block propagate signals
    wire [7:0] g_blocks; // block generate signals

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : split_inputs
            assign A_blocks[i] = A[8*i +: 8];
            assign B_blocks[i] = B_neg[8*i +: 8];
        end
    endgenerate

    // Initial carry-in for the whole addition is 1 for two's complement
    assign c_in_blocks[0] = 1'b1;

    // Instantiate eight 8-bit CLA blocks
    generate
        for (i = 0; i < 8; i = i + 1) begin : cla8_blocks
            cla_8bit cla8_inst (
                .A      (A_blocks[i]),
                .B      (B_blocks[i]),
                .cin    (c_in_blocks[i]),
                .sum    (sum_blocks[i]),
                .cout   (c_out_blocks[i]),
                .P_block(p_blocks[i]),
                .G_block(g_blocks[i])
            );
        end
    endgenerate

    // Higher-level carry lookahead for block carries
    // c_in_blocks[0] is known; compute c_in_blocks[1..8]
    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin : block_carry_gen
            if (j == 0) begin
                assign c_in_blocks[1] = g_blocks[0] | (p_blocks[0] & c_in_blocks[0]);
            end else begin
                assign c_in_blocks[j+1] = g_blocks[j] | (p_blocks[j] & c_in_blocks[j]);
            end
        end
    endgenerate

    // Combine sum blocks into final 64-bit result
    generate
        for (i = 0; i < 8; i = i + 1) begin : result_concat
            assign result[8*i +: 8] = sum_blocks[i];
        end
    endgenerate

    // Overflow detection:
    // Overflow if sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 8-bit Carry Lookahead Adder
module cla_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout,
    output wire       P_block, // block propagate (all bits propagate)
    output wire       G_block  // block generate (carry generated within block)
);
    wire [7:0] P; // propagate signals for each bit
    wire [7:0] G; // generate signals for each bit
    wire [8:0] C; // carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = cin;

    // Compute carry signals using single-level lookahead within 8 bits
    genvar k;
    generate
        for (k = 0; k < 8; k = k + 1) begin : carry_loop
            assign C[k+1] = G[k] | (P[k] & C[k]);
        end
    endgenerate

    assign sum = P ^ C[7:0];
    assign cout = C[8];

    // Block propagate: all bits must propagate
    assign P_block = &P;

    // Block generate: either last bit generates or propagate and carry-in generate
    assign G_block = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) |
                     (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) |
                     (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) |
                     (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]);
endmodule