module popcount8 (
    input  [7:0] in,
    output [3:0] out  // max 8 ones => 4 bits needed
);
    // Simple combinational popcount for 8 bits using adder tree
    wire [1:0] sum2_0 = in[1:0][0] + in[1:0][1];
    wire [1:0] sum2_1 = in[3:2][0] + in[3:2][1];
    wire [1:0] sum2_2 = in[5:4][0] + in[5:4][1];
    wire [1:0] sum2_3 = in[7:6][0] + in[7:6][1];

    // However, above doesn't synthesize as intended; better to sum bits directly
    // Correct approach: sum each bit as integer and add

    assign out = in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7];
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split 255 bits into 32 groups of 8 bits (last group 7 bits + zero pad)
    // 31 full groups of 8 bits = 248 bits + last 7 bits = 255 bits
    // For simplicity, pad the last group with 1 zero bit

    wire [7:0] groups [0:31];

    genvar i;
    generate
        for (i=0; i<31; i=i+1) begin : gen_groups
            assign groups[i] = in[i*8 +: 8];
        end
        // Last group: bits 248..254 + 1'b0 padding
        assign groups[31] = {1'b0, in[254:248]};
    endgenerate

    // Compute partial popcounts for each 8-bit group
    wire [3:0] partial_counts [0:31];
    generate
        for (i=0; i<32; i=i+1) begin : gen_popcounts
            popcount8 pc8 (
                .in(groups[i]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Now sum 32 partial counts (each 4 bits) into an 8-bit output

    // Stage 1: sum pairs of partial_counts to get 16 sums
    wire [4:0] sum16 [0:15];
    generate
        for (i=0; i<16; i=i+1) begin : sum_stage1
            assign sum16[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Stage 2: sum pairs of sum16 to get 8 sums
    wire [5:0] sum8 [0:7];
    generate
        for (i=0; i<8; i=i+1) begin : sum_stage2
            assign sum8[i] = sum16[2*i] + sum16[2*i+1];
        end
    endgenerate

    // Stage 3: sum pairs of sum8 to get 4 sums
    wire [6:0] sum4 [0:3];
    generate
        for (i=0; i<4; i=i+1) begin : sum_stage3
            assign sum4[i] = sum8[2*i] + sum8[2*i+1];
        end
    endgenerate

    // Stage 4: sum pairs of sum4 to get 2 sums
    wire [7:0] sum2 [0:1];
    generate
        for (i=0; i<2; i=i+1) begin : sum_stage4
            assign sum2[i] = sum4[2*i] + sum4[2*i+1];
        end
    endgenerate

    // Stage 5: sum last two sums to get final count
    wire [8:0] total_sum;
    assign total_sum = sum2[0] + sum2[1];

    // Output is lower 8 bits, max 255 ones so 8 bits enough
    assign out = total_sum[7:0];
endmodule