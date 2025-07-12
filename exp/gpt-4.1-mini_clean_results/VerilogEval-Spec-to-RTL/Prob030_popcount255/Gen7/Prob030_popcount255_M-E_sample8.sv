module popcount8 (
    input  [7:0] in,
    output [3:0] out  // max 8 ones => 4 bits
);
    // Simple bitwise popcount using adder tree
    wire [1:0] sum02 = in[0] + in[1];
    wire [1:0] sum13 = in[2] + in[3];
    wire [1:0] sum46 = in[4] + in[5];
    wire [1:0] sum57 = in[6] + in[7];

    wire [2:0] sum0123 = sum02 + sum13; // max 4
    wire [2:0] sum4567 = sum46 + sum57; // max 4

    assign out = sum0123 + sum4567; // max 8
endmodule

module popcount7 (
    input  [6:0] in,
    output [3:0] out  // max 7 ones => 3 bits, use 4 bits for uniformity
);
    // Similar approach as popcount8 but for 7 bits
    wire [1:0] sum02 = in[0] + in[1];
    wire [1:0] sum13 = in[2] + in[3];
    wire [1:0] sum45 = in[4] + in[5];
    wire       bit6 = in[6];

    wire [2:0] sum0123 = sum02 + sum13;  // max 4
    wire [2:0] sum4546 = sum45 + bit6;   // max 3

    assign out = sum0123 + sum4546;      // max 7
endmodule

module add5_4 (
    input  [4:0] a,
    input  [4:0] b,
    output [5:0] sum
);
    // Add two 5-bit numbers, output 6-bit sum
    assign sum = a + b;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split the 255-bit input into 32 chunks:
    // 31 chunks of 8 bits: bits [i*8 +: 8], i=0..30
    // 1 chunk of 7 bits: bits [248+:7] = bits [254:248]

    // Partial counts storage (32 values)
    wire [3:0] partial_counts [0:31];

    genvar i;
    generate
        // For chunks 0 to 30 (8 bits each)
        for (i=0; i<31; i=i+1) begin : gen_pop8
            popcount8 u_pop8 (
                .in(in[i*8 +: 8]),
                .out(partial_counts[i])
            );
        end

        // For last chunk (7 bits)
        popcount7 u_pop7 (
            .in(in[254:248]),
            .out(partial_counts[31])
        );
    endgenerate

    // Now sum all partial_counts (32 values) which are 4-bit each
    // Max sum = 255, needs 8 bits.
    // We sum in stages: pairwise add 4-bit partials into 5-bit sums, then add pairs of sums,
    // progressively reducing number of elements until one final sum remains.

    // Level 1: sum pairs of partial_counts (4-bit each) -> 5-bit sums
    wire [5:0] sum_level1 [0:15];
    generate
        for (i=0; i<16; i=i+1) begin : level1_add
            add5_4 add_inst (
                .a({1'b0, partial_counts[2*i]}),     // extend 4->5 bits
                .b({1'b0, partial_counts[2*i+1]}),
                .sum(sum_level1[i])
            );
        end
    endgenerate

    // Level 2: sum pairs of sum_level1 (6-bit each) -> 7-bit sums
    wire [6:0] sum_level2 [0:7];
    generate
        for (i=0; i<8; i=i+1) begin : level2_add
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 (7-bit each) -> 8-bit sums
    wire [7:0] sum_level3 [0:3];
    generate
        for (i=0; i<4; i=i+1) begin : level3_add
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: sum pairs of sum_level3 (8-bit each) -> 9-bit sums
    wire [8:0] sum_level4 [0:1];
    generate
        for (i=0; i<2; i=i+1) begin : level4_add
            assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
        end
    endgenerate

    // Level 5: sum the final two 9-bit sums -> 10-bit sum (max 255 fits in 8 bits, but keep width)
    wire [9:0] sum_final;
    assign sum_final = sum_level4[0] + sum_level4[1];

    // Final output is 8 bits (0..255), lower 8 bits suffice
    assign out = sum_final[7:0];

endmodule