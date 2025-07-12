module popcount4 (
    input  [3:0] in,
    output [2:0] out // max 4, needs 3 bits
);
    wire [1:0] sum01 = in[0] + in[1];
    wire [1:0] sum23 = in[2] + in[3];
    wire [3:0] total = sum01 + sum23;
    assign out = total[2:0];
endmodule

module popcount8 (
    input  [7:0] in,
    output [4:0] out // max 8, needs 4 bits, use 5 bits for addition safety
);
    wire [2:0] pc_low, pc_high;
    popcount4 pc0 (.in(in[3:0]), .out(pc_low));
    popcount4 pc1 (.in(in[7:4]), .out(pc_high));
    assign out = pc_low + pc_high; // 3+3 bits addition fits in 5 bits
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split input into 31 groups of 8 bits (last group has 255 - 30*8 = 15 bits)
    // Handle last group with separate popcount for 7 bits + 8 bits
    // Or just treat last 15 bits as 8 bits + 7 bits

    // First 31 groups of 8 bits (0 to 30)
    // Actually, 31*8 = 248 bits, remaining 7 bits (254-247)
    // So groups: 30 groups of 8 bits = 240 bits, last group 15 bits
    // For simplicity: 31 groups; last group only 7 bits, pad zeros

    wire [4:0] pc8 [30:0];
    genvar i;
    generate
        for (i = 0; i < 30; i = i +1) begin : gen_pc8
            popcount8 pc_inst (.in(in[i*8 +:8]), .out(pc8[i]));
        end
    endgenerate

    // Last group: bits 240 to 254 (15 bits) split into 8 + 7 bits
    wire [7:0] last8 = in[240 +:8];
    wire [6:0] last7 = in[248 +:7];
    wire [4:0] last8_pc;
    wire [3:0] last7_pc; // popcount7 max 7 -> 3 bits enough, 4 bits for addition

    popcount8 last8_inst (.in(last8), .out(last8_pc));
    popcount4 last7_low (.in(last7[3:0]), .out(last7_pc[2:0]));
    popcount4 last7_high (.in({3'b000, last7[6:4]}), .out(last7_pc[3])); // pad upper bits zero

    // last7_pc is sum of two popcount4 (one 4 bits, one 3 bits), sum max 7
    wire [3:0] last7_sum = last7_pc[2:0] + last7_pc[3];

    // total popcount for last 15 bits
    wire [5:0] last15_pc = last8_pc + last7_sum; // max 15, fits in 5 bits, 6 bits for safety

    // Now sum all 31 partial counts (pc8[0..29] and last15_pc)
    // Extend last15_pc to 5 bits (already 6 bits)
    // pc8 are 5 bits each

    // Balanced adder tree to sum 31 partial counts of max 8 each
    // Total max 255 fits in 8 bits

    // Level 1: sum pairs of pc8 (15 pairs) + last single (last15_pc)
    wire [7:0] sum_level1 [15:0];
    generate
        for (i=0; i<15; i=i+1) begin : sum_level1_gen
            assign sum_level1[i] = {3'b000, pc8[2*i]} + {3'b000, pc8[2*i+1]};
        end
    endgenerate
    assign sum_level1[15] = {2'b00, last15_pc}; // last partial count

    // Level 2: sum pairs from sum_level1 (8 pairs + 1 leftover)
    wire [7:0] sum_level2 [7:0];
    generate
        for (i=0; i<7; i=i+1) begin : sum_level2_gen
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate
    assign sum_level2[7] = sum_level1[15];

    // Level 3: sum pairs from sum_level2 (4 pairs)
    wire [7:0] sum_level3 [3:0];
    generate
        for (i=0; i<4; i=i+1) begin : sum_level3_gen
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i+1];
        end
    endgenerate

    // Level 4: sum pairs from sum_level3 (2 pairs)
    wire [7:0] sum_level4 [1:0];
    generate
        for (i=0; i<2; i=i+1) begin : sum_level4_gen
            assign sum_level4[i] = sum_level3[2*i] + sum_level3[2*i+1];
        end
    endgenerate

    // Level 5: final sum
    assign out = sum_level4[0] + sum_level4[1];

endmodule