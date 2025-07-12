module popcount8 (
    input  [7:0] in,
    output [4:0] out // max 8 ones, 4 bits + 1 for safety
);
    // Efficient bit counting using parallel half-adders
    wire [3:0] count2; // count of pairs
    wire [1:0] sum2_0, sum2_1, sum2_2, sum2_3;

    // count bits in pairs
    assign sum2_0 = {1'b0, in[0]} + {1'b0, in[1]};
    assign sum2_1 = {1'b0, in[2]} + {1'b0, in[3]};
    assign sum2_2 = {1'b0, in[4]} + {1'b0, in[5]};
    assign sum2_3 = {1'b0, in[6]} + {1'b0, in[7]};

    // sum pairs to get count of 8 bits
    wire [3:0] sum4_0, sum4_1;
    assign sum4_0 = sum2_0 + sum2_1; // max 4
    assign sum4_1 = sum2_2 + sum2_3; // max 4

    assign out = sum4_0 + sum4_1; // max 8 fits in 4 bits, output 5 bits for safety
endmodule

module popcount7 (
    input  [6:0] in,
    output [4:0] out // max 7 ones
);
    // Similar to popcount8 but for 7 bits
    wire [3:0] count2; 
    wire [1:0] sum2_0, sum2_1, sum2_2;

    assign sum2_0 = {1'b0, in[0]} + {1'b0, in[1]};
    assign sum2_1 = {1'b0, in[2]} + {1'b0, in[3]};
    assign sum2_2 = {1'b0, in[4]} + {1'b0, in[5]};
    wire single_bit = in[6];

    wire [3:0] sum4_0;
    assign sum4_0 = sum2_0 + sum2_1; // max 4

    wire [3:0] sum4_1;
    assign sum4_1 = sum2_2 + {1'b0, single_bit}; // max 4

    assign out = sum4_0 + sum4_1; // max 7
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Break input into 31 groups of 8 bits and 1 group of 7 bits
    wire [4:0] partial_counts [31:0]; // 32 partial sums (5 bits each)

    genvar gi;
    generate
        for (gi=0; gi < 31; gi=gi+1) begin : pc8_blocks
            popcount8 pc8 (
                .in(in[gi*8 +: 8]),
                .out(partial_counts[gi])
            );
        end
        popcount7 pc7 (
            .in(in[31*8 +: 7]),
            .out(partial_counts[31])
        );
    endgenerate

    // Now sum all 32 partial_counts (5 bits each) in a balanced adder tree

    // Level 1: sum pairs of partial_counts (16 sums)
    wire [6:0] sum_level1 [15:0]; // max sum = 2*8=16 max, fits 5 bits + carry, use 7 bits
    generate
        for (gi=0; gi < 16; gi=gi+1) begin : level1_sum
            assign sum_level1[gi] = partial_counts[2*gi] + partial_counts[2*gi+1];
        end
    endgenerate

    // Level 2: sum pairs of sum_level1 (8 sums)
    wire [7:0] sum_level2 [7:0]; // max sum = 2*16=32 fits in 6 bits, use 8 bits safe
    generate
        for (gi=0; gi < 8; gi=gi+1) begin : level2_sum
            assign sum_level2[gi] = sum_level1[2*gi] + sum_level1[2*gi+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 (4 sums)
    wire [8:0] sum_level3 [3:0]; // max sum = 2*32=64 fits in 7 bits, use 9 bits for margin
    generate
        for (gi=0; gi < 4; gi=gi+1) begin : level3_sum
            assign sum_level3[gi] = sum_level2[2*gi] + sum_level2[2*gi+1];
        end
    endgenerate

    // Level 4: sum pairs of sum_level3 (2 sums)
    wire [9:0] sum_level4 [1:0]; // max sum = 2*64=128 fits 8 bits, use 10 bits for margin
    generate
        for (gi=0; gi < 2; gi=gi+1) begin : level4_sum
            assign sum_level4[gi] = sum_level3[2*gi] + sum_level3[2*gi+1];
        end
    endgenerate

    // Level 5: final sum (2 inputs)
    wire [10:0] sum_final; // max 2*128=256 fits in 9 bits, use 11 bits for margin
    assign sum_final = sum_level4[0] + sum_level4[1];

    // Output is lower 8 bits of the total population count (max 255)
    assign out = sum_final[7:0];

endmodule