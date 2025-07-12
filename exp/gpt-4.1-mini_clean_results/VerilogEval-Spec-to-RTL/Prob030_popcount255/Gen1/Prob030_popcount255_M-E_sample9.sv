module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Internal wires to hold partial counts
    wire [3:0] partial_counts [31:0];

    genvar i;
    generate
        // Create 31 groups of 8 bits and 1 group of 7 bits
        for (i = 0; i < 31; i = i + 1) begin : groups_8bits
            PopCount8 pc8 (
                .in(in[i*8 +: 8]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // The last group has only 7 bits, so use a PopCount7
    PopCount7 pc7 (
        .in(in[248 +: 7]),
        .out(partial_counts[31])
    );

    // Now sum all 32 partial counts (4 bits each) with a balanced adder tree

    // Level 1: 16 sums of 4-bit + 4-bit = 5-bit
    wire [4:0] level1_sums [15:0];
    generate
        for (i = 0; i < 16; i = i +1) begin : level1
            assign level1_sums[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Level 2: 8 sums of 5-bit + 5-bit = 6-bit
    wire [5:0] level2_sums [7:0];
    generate
        for (i = 0; i < 8; i = i +1) begin : level2
            assign level2_sums[i] = level1_sums[2*i] + level1_sums[2*i+1];
        end
    endgenerate

    // Level 3: 4 sums of 6-bit + 6-bit = 7-bit
    wire [6:0] level3_sums [3:0];
    generate
        for (i = 0; i < 4; i = i +1) begin : level3
            assign level3_sums[i] = level2_sums[2*i] + level2_sums[2*i+1];
        end
    endgenerate

    // Level 4: 2 sums of 7-bit + 7-bit = 8-bit
    wire [7:0] level4_sums [1:0];
    generate
        for (i = 0; i < 2; i = i +1) begin : level4
            assign level4_sums[i] = level3_sums[2*i] + level3_sums[2*i+1];
        end
    endgenerate

    // Final sum: 8-bit + 8-bit = max 9 bits but max count is 255 so fits in 8 bits
    assign out = level4_sums[0] + level4_sums[1];

endmodule


// Population count of 8 bits, output 4 bits max count 8
module PopCount8 (
    input  [7:0] in,
    output [3:0] out
);
    // Sum bits using addition
    wire [3:0] sum_4_0 = in[3:0][0] + in[3:0][1] + in[3:0][2] + in[3:0][3]; // sum of lower 4 bits
    wire [3:0] sum_4_1 = in[7:4][0] + in[7:4][1] + in[7:4][2] + in[7:4][3]; // sum of upper 4 bits

    // However, above indexing is not correct. We'll do direct addition:
    assign out = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];
endmodule

// Population count of 7 bits, output 3 bits max count 7
module PopCount7 (
    input  [6:0] in,
    output [3:0] out
);
    assign out = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6];
endmodule