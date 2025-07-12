module popcount5 (
    input  [4:0] in,
    output [2:0] out  // max 5 ones -> 3 bits needed
);
    // sum bits in a parallel way
    // out = in[0]+in[1]+in[2]+in[3]+in[4]

    wire [2:0] sum_01 = in[0] + in[1];    // 2 bits max (0..2)
    wire [2:0] sum_23 = in[2] + in[3];    // 2 bits max (0..2)
    wire [3:0] sum_0123 = sum_01 + sum_23; // 3 bits max (0..4)
    wire [3:0] total_sum = sum_0123 + in[4]; // max 5, fits in 3 bits

    assign out = total_sum[2:0];
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Break input into 51 groups of 5 bits
    wire [2:0] partial_counts [50:0]; // 51 groups, each 3-bit count

    genvar gi;
    generate
        for (gi = 0; gi < 51; gi = gi + 1) begin : pop5_blocks
            popcount5 pc5 (
                .in(in[gi*5 +: 5]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Now sum these 51 partial counts hierarchically:
    // Each partial_count max 5, total max 255 (fits in 8 bits)
    // Use multiple levels of addition reducing counts by half each level

    // Level 0: partial_counts [3 bits wide]
    // We'll create successive arrays of wider bits by summing pairs

    // Level 1: sum pairs of partial_counts (max sum 10 -> 4 bits)
    localparam L1_SIZE = (51 + 1) / 2; // ceil(51/2) = 26
    wire [3:0] sum_level1 [L1_SIZE-1:0];

    generate
        for (gi = 0; gi < L1_SIZE; gi = gi + 1) begin : level1_sum
            if (2*gi+1 < 51) begin
                assign sum_level1[gi] = partial_counts[2*gi] + partial_counts[2*gi+1];
            end else begin
                // Odd count, pass through padded to 4 bits
                assign sum_level1[gi] = {1'b0, partial_counts[2*gi]};
            end
        end
    endgenerate

    // Level 2: sum pairs of sum_level1 (max 20, 5 bits)
    localparam L2_SIZE = (L1_SIZE + 1) / 2; // ceil(26/2) = 13
    wire [4:0] sum_level2 [L2_SIZE-1:0];

    generate
        for (gi = 0; gi < L2_SIZE; gi = gi + 1) begin : level2_sum
            if (2*gi+1 < L1_SIZE) begin
                assign sum_level2[gi] = sum_level1[2*gi] + sum_level1[2*gi+1];
            end else begin
                assign sum_level2[gi] = {1'b0, sum_level1[2*gi]};
            end
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 (max 40, 6 bits)
    localparam L3_SIZE = (L2_SIZE + 1) / 2; // ceil(13/2)=7
    wire [5:0] sum_level3 [L3_SIZE-1:0];

    generate
        for (gi = 0; gi < L3_SIZE; gi = gi + 1) begin : level3_sum
            if (2*gi+1 < L2_SIZE) begin
                assign sum_level3[gi] = sum_level2[2*gi] + sum_level2[2*gi+1];
            end else begin
                assign sum_level3[gi] = {1'b0, sum_level2[2*gi]};
            end
        end
    endgenerate

    // Level 4: sum pairs of sum_level3 (max 80, 7 bits)
    localparam L4_SIZE = (L3_SIZE + 1) / 2; // ceil(7/2)=4
    wire [6:0] sum_level4 [L4_SIZE-1:0];

    generate
        for (gi = 0; gi < L4_SIZE; gi = gi + 1) begin : level4_sum
            if (2*gi+1 < L3_SIZE) begin
                assign sum_level4[gi] = sum_level3[2*gi] + sum_level3[2*gi+1];
            end else begin
                assign sum_level4[gi] = {1'b0, sum_level3[2*gi]};
            end
        end
    endgenerate

    // Level 5: sum pairs of sum_level4 (max 160, 8 bits)
    localparam L5_SIZE = (L4_SIZE + 1) / 2; // ceil(4/2)=2
    wire [7:0] sum_level5 [L5_SIZE-1:0];

    generate
        for (gi = 0; gi < L5_SIZE; gi = gi + 1) begin : level5_sum
            if (2*gi+1 < L4_SIZE) begin
                assign sum_level5[gi] = sum_level4[2*gi] + sum_level4[2*gi+1];
            end else begin
                assign sum_level5[gi] = {1'b0, sum_level4[2*gi]};
            end
        end
    endgenerate

    // Level 6: final sum if needed (max 255)
    // L5_SIZE can be 2 or 1 depending on parity (here 2)
    wire [7:0] final_sum;
    assign final_sum = sum_level5[0] + sum_level5[1];

    assign out = final_sum;

endmodule