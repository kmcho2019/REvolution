module popcount3 (
    input  [2:0] in,
    output [1:0] out  // max sum 3 -> needs 2 bits
);
    // Sum of 3 bits: out = in[0] + in[1] + in[2]
    // 3 bits sum range 0..3
    assign out = in[0] + in[1] + in[2];
endmodule

module kogge_stone_adder #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH:0] sum
);
    // Kogge-Stone prefix adder implementation for fast addition
    wire [WIDTH-1:0] p; // propagate
    wire [WIDTH-1:0] g; // generate
    wire [WIDTH:0] c;   // carry

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = 1'b0;

    genvar i, j;
    generate
        // Declare carry generate/propagate wires for stages
        // Stage width doubles each time (prefix tree)
        integer stage, width;
        wire [WIDTH-1:0] gnpg [0:$clog2(WIDTH)-1];
        wire [WIDTH-1:0] pp    [0:$clog2(WIDTH)-1];

        // Assign initial stage 0 propagate/generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            assign gnpg[0][i] = g[i];
            assign pp[0][i]   = p[i];
        end

        for (stage = 1; stage < $clog2(WIDTH); stage = stage + 1) begin : prefix_stages
            localparam shift = 1 << (stage - 1);
            for (i = 0; i < WIDTH; i = i + 1) begin : prefix_bits
                if (i >= (shift << 1)) begin
                    assign gnpg[stage][i] = gnpg[stage-1][i] | (pp[stage-1][i] & gnpg[stage-1][i - (shift << 1)]);
                    assign pp[stage][i]   = pp[stage-1][i] & pp[stage-1][i - (shift << 1)];
                end else if (i >= shift) begin
                    assign gnpg[stage][i] = gnpg[stage-1][i] | (pp[stage-1][i] & gnpg[stage-1][i - shift]);
                    assign pp[stage][i]   = pp[stage-1][i] & pp[stage-1][i - shift];
                end else begin
                    assign gnpg[stage][i] = gnpg[stage-1][i];
                    assign pp[stage][i]   = pp[stage-1][i];
                end
            end
        end

        // Carry out assignment after prefix
        for (i = 1; i <= WIDTH; i = i + 1) begin : assign_carry
            if (i == 1) begin
                assign c[i] = gnpg[$clog2(WIDTH)-1][i-1];
            end else begin
                assign c[i] = gnpg[$clog2(WIDTH)-1][i-1];
            end
        end
    endgenerate

    // Sum bits
    assign sum = p ^ c[WIDTH-1:0];
    assign sum[WIDTH] = c[WIDTH]; // final carry out
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Step 1: group input bits into 3-bit groups, 255 bits / 3 = 85 groups (last group has 3 bits)
    // last group must handle 255 bits exactly, no leftover bits.

    localparam GROUPS = 85;

    wire [1:0] group_sums [GROUPS-1:0];

    genvar i;
    generate
        for (i = 0; i < GROUPS; i = i + 1) begin : group_popcount3
            popcount3 pc3 (
                .in(in[3*i +: 3]),
                .out(group_sums[i])
            );
        end
    endgenerate

    // Step 2: sum the 85 2-bit group_sums

    // Flatten group_sums into a single vector for addition
    // Each group_sum is 2 bits, so 85*2=170 bits

    wire [169:0] flat_group_sums;
    generate
        for (i = 0; i < GROUPS; i = i + 1) begin : flatten
            assign flat_group_sums[2*i +: 2] = group_sums[i];
        end
    endgenerate

    // Now sum these 85 2-bit values => sum range 0 to 255 (max population count)
    // Use a tree of kogge_stone adders to sum these 2-bit groups pairwise until final sum

    // For simplicity, sum the 85 2-bit values by accumulating all as a big number (bit concatenation)
    // This is the same as summing all 2-bit numbers => total is <=255

    // So perform parallel addition:
    // We can implement a multi-operand adder by summing the 2-bit numbers with carry-save adders.
    // To keep it simple, unroll pairwise additions of 2-bit numbers to a final sum.

    // For better clarity and synthesis efficiency, sum in two stages:
    // Stage 1: sum 85 2-bit numbers into a 8-bit output using a custom adder tree.

    // We'll implement a balanced binary adder tree adding 2-bit partial sums into 8-bit sums.

    // First level: sum pairs of 2-bit numbers => 3-bit sums
    // If odd number, last passes directly to next level.

    localparam LEVEL1_WIDTH = 3;
    localparam LEVEL2_WIDTH = 5;
    localparam LEVEL3_WIDTH = 8;

    // Level 1 sums: 42 pairs (from 84 groups) plus 1 leftover group sums => total 43 sums
    wire [LEVEL1_WIDTH-1:0] sum_level1 [42:0];
    generate
        for (i = 0; i < 42; i = i + 1) begin : level1_sum_pairs
            assign sum_level1[i] = group_sums[2*i] + group_sums[2*i + 1];
        end
        // odd leftover last element
        assign sum_level1[42] = {1'b0, group_sums[84]};
    endgenerate

    // Level 2 sums: sum pairs of 3-bit numbers -> outputs 5-bit numbers (max sum 3+3=6, but sum up to 2*7=14 bits; 5 bits safe)
    // 43 sums -> 21 pairs + 1 leftover = 22 sums
    wire [LEVEL2_WIDTH-1:0] sum_level2 [21:0];
    generate
        for (i = 0; i < 21; i = i + 1) begin : level2_sum_pairs
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i + 1];
        end
        assign sum_level2[21] = {2'b0, sum_level1[42]}; // zero-extend leftover
    endgenerate

    // Level 3 sums: sum pairs of 5-bit numbers -> outputs 8-bit numbers (max sum 31+31=62)
    // 22 sums -> 11 pairs
    wire [LEVEL3_WIDTH-1:0] sum_level3 [10:0];
    generate
        for (i = 0; i < 11; i = i + 1) begin : level3_sum_pairs
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i + 1];
        end
    endgenerate

    // Level 4 sums: sum pairs of 8-bit numbers -> outputs 9 bits (max sum 255)
    // 11 sums -> 5 pairs + 1 leftover = 6 sums
    wire [8:0] sum_level4 [5:0];
    generate
        for (i = 0; i < 5; i = i + 1) begin : level4_sum_pairs
            assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i + 1];
        end
        assign sum_level4[5] = {1'b0, sum_level3[10]};
    endgenerate

    // Level 5 sums: sum pairs of 9-bit numbers -> outputs 10 bits
    // 6 sums -> 3 pairs
    wire [9:0] sum_level5 [2:0];
    generate
        for (i = 0; i < 3; i = i + 1) begin : level5_sum_pairs
            assign sum_level5[i] = sum_level4[2*i] + sum_level4[2*i + 1];
        end
    endgenerate

    // Level 6 sums: sum a pair plus leftover
    // 3 sums -> sum first two and then add leftover
    wire [10:0] sum_level6;
    assign sum_level6 = sum_level5[0] + sum_level5[1] + {1'b0, sum_level5[2]};

    // The output is max 255 (8 bits), limit to 8 bits for output
    assign out = sum_level6[7:0];

endmodule