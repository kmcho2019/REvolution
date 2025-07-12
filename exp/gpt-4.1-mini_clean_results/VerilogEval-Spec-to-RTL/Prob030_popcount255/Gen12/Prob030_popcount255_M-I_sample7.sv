module popcount8 (
    input  [7:0] in,
    output [3:0] out
);
    // Efficient 8-bit popcount using adder tree
    wire [3:0] sum_level1;
    assign sum_level1[0] = in[0] + in[1];
    assign sum_level1[1] = in[2] + in[3];
    assign sum_level1[2] = in[4] + in[5];
    assign sum_level1[3] = in[6] + in[7];

    wire [4:0] sum_level2_0 = sum_level1[0] + sum_level1[1];
    wire [4:0] sum_level2_1 = sum_level1[2] + sum_level1[3];

    assign out = sum_level2_0 + sum_level2_1; // max sum 8 (3 bits + 2 bits = 4 bits)
endmodule

module popcount7 (
    input  [6:0] in,
    output [3:0] out
);
    // 7-bit popcount similarly done with addition tree
    wire [3:0] sum_level1;
    assign sum_level1[0] = in[0] + in[1];
    assign sum_level1[1] = in[2] + in[3];
    assign sum_level1[2] = in[4] + in[5];
    assign sum_level1[3] = in[6];

    wire [4:0] sum_level2_0 = sum_level1[0] + sum_level1[1];
    wire [4:0] sum_level2_1 = sum_level1[2] + sum_level1[3];

    assign out = sum_level2_0 + sum_level2_1; // max sum 7 (3 bits + 2 bits)
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split input into 31 chunks:
    // 31 chunks = 30 chunks of 8 bits + 1 chunk of 7 bits = 255 bits total

    wire [3:0] partial_counts [30:0]; // 31 partial sums max 8 for each chunk

    genvar i;
    generate
        for (i=0; i < 30; i=i+1) begin : chunk_popcount8
            popcount8 u_pop8 (
                .in(in[8*i +: 8]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    popcount7 u_pop7 (
        .in(in[8*30 +: 7]),
        .out(partial_counts[30])
    );

    // Now sum partial_counts[0..30], each is 4 bits max sum 8, total max sum 255
    // Sum in balanced tree stages:

    // Stage 1: sum pairs (15 pairs), one leftover
    wire [7:0] sum_stage1 [15:0]; // 16 elements, 1 leftover = 31 items total

    generate
        for (i=0; i<15; i=i+1) begin : sum_pairs_stage1
            assign sum_stage1[i] = partial_counts[2*i] + partial_counts[2*i+1]; // 4b + 4b = 6 bits max (16)
        end
    endgenerate
    // leftover partial_counts[30]
    assign sum_stage1[15] = partial_counts[30];

    // Stage 2: sum pairs of stage1 (8 pairs)
    wire [7:0] sum_stage2 [7:0];
    generate
        for (i=0; i<8; i=i+1) begin : sum_pairs_stage2
            if (2*i+1 < 16) begin
                assign sum_stage2[i] = sum_stage1[2*i] + sum_stage1[2*i+1]; // 8b + 8b = 9 bits max (max 255)
            end else begin
                assign sum_stage2[i] = sum_stage1[2*i];
            end
        end
    endgenerate

    // Stage 3: sum pairs of stage2 (4 pairs)
    wire [8:0] sum_stage3 [3:0]; // 9 bits max
    generate
        for (i=0; i<4; i=i+1) begin : sum_pairs_stage3
            assign sum_stage3[i] = sum_stage2[2*i] + sum_stage2[2*i+1];
        end
    endgenerate

    // Stage 4: sum pairs of stage3 (2 pairs)
    wire [9:0] sum_stage4 [1:0];
    generate
        for (i=0; i<2; i=i+1) begin : sum_pairs_stage4
            assign sum_stage4[i] = sum_stage3[2*i] + sum_stage3[2*i+1];
        end
    endgenerate

    // Stage 5: final sum
    wire [10:0] sum_stage5 = sum_stage4[0] + sum_stage4[1]; // 11 bits max but max 255 decimal fits in 8 bits output

    assign out = sum_stage5[7:0]; // truncate upper bits, guaranteed max 255

endmodule