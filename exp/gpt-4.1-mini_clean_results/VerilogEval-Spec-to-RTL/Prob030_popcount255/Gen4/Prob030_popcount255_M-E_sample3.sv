module popcount3 (
    input  [2:0] in,
    output [1:0] out  // max 3 ones, 2 bits sufficient
);
    // Sum bits explicitly:
    assign out = in[0] + in[1] + in[2];
endmodule

module adderN #(parameter WIDTH=8) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] sum
);
    assign sum = a + b;
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split 255 bits into 85 groups of 3 bits:
    wire [1:0] pop3_results [84:0];

    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : gen_pop3
            popcount3 pc3 (
                .in(in[i*3 +: 3]),
                .out(pop3_results[i])
            );
        end
    endgenerate

    // Now sum these 85 2-bit partial sums using a balanced adder tree.
    // Level 1: Pairwise sum of pop3_results (2 bits each)
    // 85 inputs -> 42 pairs + 1 leftover

    // Level1 sums are 3 bits max: max sum(3+3)=6, needs 3 bits
    wire [2:0] sum_level1 [41:0];
    wire [1:0] leftover_lvl1;

    generate
        for (i = 0; i < 42; i = i + 1) begin : gen_level1
            // sum pairs of 2-bit values into 3-bit sum
            assign sum_level1[i] = pop3_results[2*i] + pop3_results[2*i+1];
        end
    endgenerate
    assign leftover_lvl1 = pop3_results[84]; // last unpaired 2-bit value

    // Level 2: sum_level1 has 42 3-bit values + 1 leftover 2-bit (zero-extend)
    // Sum pairs of sum_level1 + leftover (total 43 inputs)
    // Pair sums:
    // 21 pairs + 1 leftover

    wire [3:0] sum_level2 [20:0]; // 4 bits needed (max 6+6=12 fits in 4 bits)
    wire [2:0] leftover_lvl2;

    generate
        for (i = 0; i < 21; i = i + 1) begin : gen_level2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate
    // leftover_lvl2 is sum_level1[42] + zero extended leftover_lvl1 (2 bits to 3 bits)
    // sum_level1[42] does not exist, so leftover_lvl2 is sum of leftover_lvl1 and zero
    // Actually sum_level1 has indices 0..41, 42 elements total, so index 42 does not exist
    // So leftover_lvl2 = leftover_lvl1 zero-extended to 3 bits
    assign leftover_lvl2 = {1'b0, leftover_lvl1};

    // Level 3: sum_level2 has 21 4-bit values + leftover_lvl2 (3 bits zero-extended to 4 bits)
    // So 22 inputs at level 3.

    // Sum pairs: 11 pairs, leftover 1
    wire [4:0] sum_level3 [10:0]; // 5 bits (max 12+12=24 fits in 5 bits)
    wire [3:0] leftover_lvl3;

    generate
        for (i = 0; i < 10; i = i + 1) begin : gen_level3
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate
    assign leftover_lvl3 = sum_level2[20] + {1'b0, leftover_lvl2}; // sum leftover_lvl2 zero-extended to 4 bits

    // Level 4: sum_level3 has 11 5-bit values (indices 0..10)
    // sum pairs: 5 pairs, leftover 1
    wire [5:0] sum_level4 [4:0]; // 6 bits (max 24+24=48 fits in 6 bits)
    wire [4:0] leftover_lvl4;

    generate
        for (i = 0; i < 5; i = i + 1) begin : gen_level4
            assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
        end
    endgenerate
    assign leftover_lvl4 = sum_level3[10] + {1'b0, leftover_lvl3}; // leftover_lvl3 zero-extended 5 bits

    // Level 5: sum_level4 has 6 values (5 sums + 1 leftover)
    // sum pairs: 3 pairs
    wire [6:0] sum_level5 [2:0]; // 7 bits (max 48+48=96 fits in 7 bits)

    generate
        for (i = 0; i < 3; i = i + 1) begin : gen_level5
            assign sum_level5[i] = sum_level4[2*i] + sum_level4[2*i+1];
        end
    endgenerate
    // leftover_lvl5: leftover_lvl4 zero-extended 6 bits
    wire [6:0] leftover_lvl5 = {1'b0, leftover_lvl4};

    // Level 6: sum_level5 has 3 sums + leftover 1
    // sum pairs: 1 pair + leftover 2
    wire [7:0] sum_level6_0; // 8 bits (max 96+96=192 fits in 8 bits)
    wire [7:0] leftover_lvl6_1, leftover_lvl6_2;

    assign sum_level6_0 = sum_level5[0] + sum_level5[1];
    assign leftover_lvl6_1 = sum_level5[2]; // 7 bits zero-extended to 8 bits
    assign leftover_lvl6_2 = leftover_lvl5; // 7 bits zero-extended to 8 bits

    // Level 7: sum three 8-bit values
    wire [8:0] sum_level7_0; // 9 bits (max 192+96+96=384 fits in 9 bits)

    assign sum_level7_0 = sum_level6_0 + leftover_lvl6_1 + leftover_lvl6_2;

    // The max number of ones in 255 bits is 255 (0xFF), so 8 bits suffice,
    // but here summation width reached 9 bits; final cap to 8 bits by ignoring MSB (or saturating)
    // Since max is 255, 8 bits enough, so just assign lower 8 bits:
    assign out = sum_level7_0[7:0];

endmodule