module popcount8 (
    input  [7:0] in,
    output [4:0] out // max 8 ones = 4 bits, use 5 bits for margin
);
    // Balanced tree summation of 8 bits into 5 bits
    wire [3:0] sum_level1 [3:0]; // sum pairs of bits (2 bits each)
    wire [2:0] sum_level2 [1:0];
    wire [3:0] sum_level3;

    // Level 1: sum pairs of bits (2 bits max = 2)
    assign sum_level1[0] = in[1] + in[0];
    assign sum_level1[1] = in[3] + in[2];
    assign sum_level1[2] = in[5] + in[4];
    assign sum_level1[3] = in[7] + in[6];

    // Level 2: sum pairs of sum_level1 (max 4)
    assign sum_level2[0] = sum_level1[1] + sum_level1[0]; // max 4
    assign sum_level2[1] = sum_level1[3] + sum_level1[2]; // max 4

    // Level 3: sum the two results (max 8)
    assign sum_level3 = sum_level2[1] + sum_level2[0];

    assign out = sum_level3; // 5 bits wide
endmodule

module popcount17 (
    input  [16:0] in,
    output [5:0] out  // max 17 ones => 5 bits, use 6 bits for margin
);
    wire [4:0] count8_0;
    wire [4:0] count8_1;
    wire [5:0] sum_8_8_1;

    popcount8 pc8_0 (.in(in[7:0]),   .out(count8_0));
    popcount8 pc8_1 (.in(in[15:8]),  .out(count8_1));

    // Add the two 5-bit counts plus the last bit (in[16])
    // sum = count8_0 + count8_1 + in[16]
    assign sum_8_8_1 = count8_0 + count8_1 + in[16];

    assign out = sum_8_8_1;
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Break input into 15 groups of 17 bits (15*17=255)
    wire [5:0] partial_counts [14:0]; // 15 partial counts

    genvar gi;
    generate
        for (gi = 0; gi < 15; gi = gi + 1) begin : pc17_blocks
            popcount17 pc (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Now sum 15 partial counts (each max 17) into one 8-bit output
    // Max sum = 15 * 17 = 255 fits in 8 bits

    // Sum partial_counts in a balanced adder tree manner:

    wire [7:0] sum_level1 [7:0];
    genvar i;

    // Level 1: sum pairs of partial_counts
    generate
        for (i = 0; i < 7; i = i + 1) begin : level1_sum
            assign sum_level1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
        // Last one (15th) passes through
        assign sum_level1[7] = {2'b00, partial_counts[14]}; // zero-extend to 8 bits
    endgenerate

    // Level 2: sum pairs of sum_level1 outputs (8 inputs)
    wire [7:0] sum_level2 [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2_sum
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 outputs (4 inputs)
    wire [7:0] sum_level3 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : level3_sum
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: sum final two outputs (2 inputs)
    assign out = sum_level3[0] + sum_level3[1];

endmodule