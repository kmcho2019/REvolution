module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones fits in 4 bits
);
    // Explicit popcount by summing bits, no loops or functions
    wire [2:0] sum_lo, sum_hi;

    assign sum_lo = in[0] + in[1] + in[2] + in[3]; // max 4, needs 3 bits
    assign sum_hi = in[4] + in[5] + in[6] + in[7]; // max 4, needs 3 bits
    assign out = sum_lo + sum_hi;                   // 3-bit + 3-bit = 4-bit sum
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split 255-bit input into 32 groups of 8 bits (last group 7 bits padded with zero)
    wire [7:0] chunks [31:0];

    genvar gi;
    generate
        for (gi = 0; gi < 31; gi = gi + 1) begin : chunk_assign_full
            assign chunks[gi] = in[gi*8 +: 8];
        end
    endgenerate

    // Last chunk: 7 bits padded with zero MSB
    assign chunks[31] = {1'b0, in[254:248]}; // 7 bits + 1 zero padding MSB

    // Instantiate 32 popcount8 modules for each 8-bit chunk
    wire [3:0] pc8 [31:0];
    generate
        for (gi = 0; gi < 32; gi = gi + 1) begin : pc8_blocks
            popcount8 pc8_inst (
                .in(chunks[gi]),
                .out(pc8[gi])
            );
        end
    endgenerate

    // Balanced summation tree of popcount8 outputs
    // Level 1: 16 sums of 4-bit + 4-bit => 5 bits max (max 8+8=16)
    wire [4:0] sum_l1 [15:0];
    generate
        for (gi = 0; gi < 16; gi = gi + 1) begin : sum_l1_blocks
            assign sum_l1[gi] = pc8[gi*2] + pc8[gi*2+1];
        end
    endgenerate

    // Level 2: 8 sums of 5-bit + 5-bit => 6 bits max (max 16+16=32)
    wire [5:0] sum_l2 [7:0];
    generate
        for (gi = 0; gi < 8; gi = gi + 1) begin : sum_l2_blocks
            assign sum_l2[gi] = sum_l1[gi*2] + sum_l1[gi*2+1];
        end
    endgenerate

    // Level 3: 4 sums of 6-bit + 6-bit => 7 bits max (max 32+32=64)
    wire [6:0] sum_l3 [3:0];
    generate
        for (gi = 0; gi < 4; gi = gi + 1) begin : sum_l3_blocks
            assign sum_l3[gi] = sum_l2[gi*2] + sum_l2[gi*2+1];
        end
    endgenerate

    // Level 4: 2 sums of 7-bit + 7-bit => 8 bits max (max 64+64=128)
    wire [7:0] sum_l4 [1:0];
    generate
        for (gi = 0; gi < 2; gi = gi + 1) begin : sum_l4_blocks
            assign sum_l4[gi] = sum_l3[gi*2] + sum_l3[gi*2+1];
        end
    endgenerate

    // Level 5: final sum of two 8-bit sums, output 8 bits max (max 128+128=256 but max count 255)
    assign out = sum_l4[0] + sum_l4[1];

endmodule