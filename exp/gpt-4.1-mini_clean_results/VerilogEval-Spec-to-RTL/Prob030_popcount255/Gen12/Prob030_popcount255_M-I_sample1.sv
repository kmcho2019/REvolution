module popcount17 (
    input  [16:0] in,
    output [5:0] out // 6 bits to cover max 17 ones safely
);
    // Use a parallel reduction by summing groups of bits directly with smaller adders.

    // First stage: count bits in 3 groups of 5 bits + leftover 2 bits
    wire [2:0] c0 = in[4:0];
    wire [2:0] c1 = in[9:5];
    wire [2:0] c2 = in[14:10];
    wire       c3 = in[15];
    wire       c4 = in[16];

    // Count bits by popcount of smaller groups - use simple addition
    // Sum bits in first 5-bit groups by adding individual bits (or use a parallel reduction)
    wire [3:0] sum0 = in[0] + in[1] + in[2] + in[3] + in[4];
    wire [3:0] sum1 = in[5] + in[6] + in[7] + in[8] + in[9];
    wire [3:0] sum2 = in[10] + in[11] + in[12] + in[13] + in[14];

    // Sum all partial sums plus last two bits
    wire [6:0] total = sum0 + sum1 + sum2 + c3 + c4;

    assign out = total[5:0]; // max 17 ones fit within 6 bits

endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    localparam CHUNKS = 15;
    wire [5:0] pc_counts [CHUNKS-1:0];

    genvar i;
    generate
        for (i = 0; i < CHUNKS; i = i + 1) begin : pcs
            popcount17 pc_inst (
                .in(in[i*17 +: 17]),
                .out(pc_counts[i])
            );
        end
    endgenerate

    // Adder tree summation of pc_counts[0..14]

    // We will sum the 6-bit pc_counts array in a binary tree style,
    // dynamically reducing the width as we go by extending sums only as needed.

    // To hold intermediate sums at each level, use a variable size vector array.

    // Level arrays: max depth ceil(log2(15))=4 levels (0..4)
    // Level 0: 15 counts of 6 bits each
    // Level 1: ceil(15/2)=8 sums, max bits: 7 (6+1)
    // Level 2: ceil(8/2)=4 sums, max bits: 8
    // Level 3: ceil(4/2)=2 sums, max bits: 9
    // Level 4: 1 sum, max bits: 10 bits (since max sum = 255)

    // Define per-level widths:
    localparam int WIDTH_L0 = 6;
    localparam int WIDTH_L1 = WIDTH_L0 + 1; // 7 bits
    localparam int WIDTH_L2 = WIDTH_L1 + 1; // 8 bits
    localparam int WIDTH_L3 = WIDTH_L2 + 1; // 9 bits
    localparam int WIDTH_L4 = WIDTH_L3 + 1; // 10 bits

    // Level 0 wires (pc_counts already declared)

    // Level 1 wires
    wire [WIDTH_L1-1:0] sums_lvl1 [7:0];
    // Level 2 wires
    wire [WIDTH_L2-1:0] sums_lvl2 [3:0];
    // Level 3 wires
    wire [WIDTH_L3-1:0] sums_lvl3 [1:0];
    // Level 4 wires
    wire [WIDTH_L4-1:0] sums_lvl4;

    // Level 1: sum pairs from pc_counts, last one passed through
    genvar j;
    generate
        for (j = 0; j < 7; j = j + 1) begin : lvl1_sum_loop
            assign sums_lvl1[j] = {1'b0, pc_counts[2*j]} + {1'b0, pc_counts[2*j+1]};
        end
    endgenerate
    // Handle last odd element directly (pc_counts[14])
    assign sums_lvl1[7] = {1'b0, pc_counts[14]};

    // Level 2: sum pairs from level 1, last one passed through if needed
    genvar k;
    generate
        for (k = 0; k < 3; k = k + 1) begin : lvl2_sum_loop
            assign sums_lvl2[k] = {1'b0, sums_lvl1[2*k]} + {1'b0, sums_lvl1[2*k+1]};
        end
    endgenerate
    // Handle last odd element sums_lvl1[7]
    assign sums_lvl2[3] = {1'b0, sums_lvl1[7]};

    // Level 3: sum pairs from level 2
    generate
        for (k = 0; k < 1; k = k + 1) begin : lvl3_sum_loop
            assign sums_lvl3[k] = {1'b0, sums_lvl2[2*k]} + {1'b0, sums_lvl2[2*k+1]};
        end
    endgenerate
    // Handle last odd element sums_lvl2[3]
    assign sums_lvl3[1] = {1'b0, sums_lvl2[3]};

    // Level 4: final sum
    assign sums_lvl4 = {1'b0, sums_lvl3[0]} + {1'b0, sums_lvl3[1]};

    // Output truncated to 8 bits (max 255)
    assign out = sums_lvl4[7:0];

endmodule