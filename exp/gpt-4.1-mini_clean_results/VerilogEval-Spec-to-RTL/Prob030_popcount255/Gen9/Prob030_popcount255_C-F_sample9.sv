module popcount8 (
    input  [7:0] in,
    output [3:0] out // max 8 ones fits in 4 bits
);
    // Balanced explicit adder tree for 8 bits

    // Level 1: sum pairs of bits (4 sums)
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    // Level 2: sum pairs of 2-bit values (2 sums)
    wire [2:0] sum_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    // Level 3: final sum of two 3-bit values (1 sum)
    assign out = sum_l2[0] + sum_l2[1];

endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Divide input into 32 chunks of 8 bits each
    // 31 full chunks and 1 partial chunk (7 bits + 1 zero padding)
    // Instantiate 32 popcount8 modules structurally using generate

    wire [3:0] pc8 [31:0]; // each 4-bit popcount8 output

    genvar gi;
    generate
        for (gi = 0; gi < 31; gi = gi + 1) begin : popcount_blocks
            popcount8 pc8_inst (
                .in(in[gi*8 +: 8]),
                .out(pc8[gi])
            );
        end
    endgenerate

    // Last chunk is 7 bits from in[254:248], padded MSB zero
    wire [7:0] last_chunk = {1'b0, in[254:248]};
    popcount8 last_pc8 (
        .in(last_chunk),
        .out(pc8[31])
    );

    // Balanced adder tree summation of 32 partial counts pc8[]
    // Bit widths chosen based on max sums at each level

    // Level 1: sum pairs of 4-bit values -> 5-bit outputs (max 16)
    wire [4:0] sum_l1 [15:0];
    generate
        for (gi = 0; gi < 16; gi = gi + 1) begin : sum_level1
            assign sum_l1[gi] = pc8[2*gi] + pc8[2*gi + 1];
        end
    endgenerate

    // Level 2: sum pairs of 5-bit values -> 6-bit outputs (max 32)
    wire [5:0] sum_l2 [7:0];
    generate
        for (gi = 0; gi < 8; gi = gi + 1) begin : sum_level2
            assign sum_l2[gi] = sum_l1[2*gi] + sum_l1[2*gi + 1];
        end
    endgenerate

    // Level 3: sum pairs of 6-bit values -> 7-bit outputs (max 64)
    wire [6:0] sum_l3 [3:0];
    generate
        for (gi = 0; gi < 4; gi = gi + 1) begin : sum_level3
            assign sum_l3[gi] = sum_l2[2*gi] + sum_l2[2*gi + 1];
        end
    endgenerate

    // Level 4: sum pairs of 7-bit values -> 8-bit outputs (max 128)
    wire [7:0] sum_l4 [1:0];
    generate
        for (gi = 0; gi < 2; gi = gi + 1) begin : sum_level4
            assign sum_l4[gi] = sum_l3[2*gi] + sum_l3[2*gi + 1];
        end
    endgenerate

    // Level 5: final sum of two 8-bit values -> 8-bit output (max 255)
    assign out = sum_l4[0] + sum_l4[1];

endmodule