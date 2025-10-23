module popcount16 (
    input  wire [15:0] in,
    output wire [4:0]  out
);
    // Parallel popcount for 16 bits using a balanced adder tree
    // Level 1: sum adjacent bits (8 sums of 2 bits)
    wire [1:0] sum2 [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : sum_pairs
            assign sum2[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    // Level 2: sum adjacent pairs (4 sums of 4 bits)
    wire [2:0] sum4 [3:0];
    generate
        for (i=0; i<4; i=i+1) begin : sum4s
            assign sum4[i] = sum2[2*i] + sum2[2*i+1];
        end
    endgenerate

    // Level 3: sum adjacent pairs (2 sums of 8 bits)
    wire [3:0] sum8 [1:0];
    generate
        for (i=0; i<2; i=i+1) begin : sum8s
            assign sum8[i] = sum4[2*i] + sum4[2*i+1];
        end
    endgenerate

    // Level 4: sum final two sums (16 bits)
    assign out = sum8[0] + sum8[1];
endmodule

module popcount15 (
    input  wire [14:0] in,
    output wire [3:0]  out
);
    // Popcount for 15 bits using 8-bit and 7-bit partial counts
    // Use popcount8 and popcount7 internally
    wire [3:0] pc8;
    wire [3:0] pc7;

    // 8-bit popcount
    popcount8 u_pc8 (.in(in[14:7]), .out(pc8));
    // 7-bit popcount
    popcount7 u_pc7 (.in(in[6:0]), .out(pc7));

    assign out = pc8 + pc7;
endmodule

module popcount8 (
    input  wire [7:0] in,
    output wire [3:0] out
);
    // Parallel popcount for 8 bits using a balanced adder tree
    wire [1:0] sum2 [3:0];
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : sum_pairs8
            assign sum2[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum4 [1:0];
    generate
        for (i=0; i<2; i=i+1) begin : sum4s8
            assign sum4[i] = sum2[2*i] + sum2[2*i+1];
        end
    endgenerate

    assign out = sum4[0] + sum4[1];
endmodule

module popcount7 (
    input  wire [6:0] in,
    output wire [3:0] out
);
    // Popcount for 7 bits = popcount4 + popcount3
    wire [2:0] pc4;
    wire [2:0] pc3;

    popcount4 u_pc4 (.in(in[6:3]), .out(pc4));
    popcount3 u_pc3 (.in(in[2:0]), .out(pc3));

    assign out = pc4 + pc3;
endmodule

module popcount4 (
    input  wire [3:0] in,
    output wire [2:0] out
);
    // 4 bits popcount by adding bits directly
    assign out = in[0] + in[1] + in[2] + in[3];
endmodule

module popcount3 (
    input  wire [2:0] in,
    output wire [2:0] out
);
    assign out = in[0] + in[1] + in[2];
endmodule

module TopModule (
    input  wire [254:0] in,
    output wire [7:0] out
);
    // Partition input into 15 groups of 16 bits and 1 group of 15 bits
    // Groups 0 to 14: 16 bits each (total 15*16=240 bits)
    // Group 15: last 15 bits (254 downto 240)

    wire [4:0] pc16_vals [14:0];
    genvar i;
    generate
        for (i=0; i<15; i=i+1) begin : popcount16_blocks
            popcount16 pc16_inst (
                .in(in[16*i +: 16]),
                .out(pc16_vals[i])
            );
        end
    endgenerate

    wire [3:0] pc15_val;
    popcount15 pc15_inst (
        .in(in[254:240]),
        .out(pc15_val)
    );

    // Sum all 16 partial counts: 15 values of 5 bits + 1 value of 4 bits
    // Maximum sum: 15*16 + 15 = 255 fits in 8 bits
    // Use a balanced adder tree for summation

    // Level 1: sum pairs of pc16_vals into 6-bit sums
    wire [5:0] sum_lvl1 [7:0];
    generate
        for (i=0; i<7; i=i+2) begin : lvl1_pairs
            assign sum_lvl1[i/2] = pc16_vals[i] + pc16_vals[i+1];
        end
    endgenerate
    // pc16_vals[14] unpaired, added later with pc15_val

    // sum_lvl1 array has 4 sums (since 7 values are paired -> 3 pairs, one leftover)
    // Correction: actually 15 values -> 7 pairs (14 values) + 1 leftover
    // So loop corrected:

    // Level 1: sum pairs of pc16_vals (indices 0&1,2&3,...,12&13)
    // pc16_vals[14] leftover

    wire [5:0] sum_lvl1_pairs [6:0]; // 7 pairs
    generate
        for (i=0; i<7; i=i+1) begin : lvl1_pair_all
            assign sum_lvl1_pairs[i] = pc16_vals[2*i] + pc16_vals[2*i +1];
        end
    endgenerate
    wire [4:0] leftover_pc16 = pc16_vals[14];

    // Level 2: sum pairs of sum_lvl1_pairs (indices 0&1,2&3,4&5)
    wire [6:0] sum_lvl2_pairs [2:0];
    generate
        for (i=0; i<3; i=i+1) begin : lvl2_pair
            assign sum_lvl2_pairs[i] = sum_lvl1_pairs[2*i] + sum_lvl1_pairs[2*i+1];
        end
    endgenerate
    // sum_lvl1_pairs[6] leftover

    wire [5:0] leftover_lvl1_6 = sum_lvl1_pairs[6];

    // Level 3: sum pairs of sum_lvl2_pairs (indices 0&1)
    wire [7:0] sum_lvl3_pair0;
    wire [6:0] sum_lvl3_leftover;
    assign sum_lvl3_pair0 = sum_lvl2_pairs[0] + sum_lvl2_pairs[1];
    assign sum_lvl3_leftover = sum_lvl2_pairs[2];

    // Level 4: sum sum_lvl3_pair0 + sum_lvl3_leftover
    wire [7:0] sum_lvl4 = sum_lvl3_pair0 + sum_lvl3_leftover;

    // Add leftovers: leftover_lvl1_6 (6 bits), leftover_pc16 (5 bits), pc15_val (4 bits)
    wire [8:0] partial_sum1 = sum_lvl4 + leftover_lvl1_6; // sum_lvl4 8 bits + leftover_lvl1_6 6 bits
    wire [8:0] partial_sum2 = partial_sum1 + leftover_pc16; // + 5 bits
    wire [8:0] partial_sum_final = partial_sum2 + {5'b0, pc15_val}; // pc15_val zero-extended

    // Final output truncated or assigned as 8-bit (max sum 255 fits in 8 bits)
    assign out = partial_sum_final[7:0];
endmodule