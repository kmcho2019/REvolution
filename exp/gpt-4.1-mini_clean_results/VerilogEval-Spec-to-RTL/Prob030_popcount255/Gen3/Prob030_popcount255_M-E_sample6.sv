module popcount3 (
    input  [2:0] in,
    output [1:0] out // max 3 ones -> 2 bits enough
);
    // Simple combinational logic for counting bits in 3-bit vector
    assign out = in[0] + in[1] + in[2];
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Split 255 bits into 85 blocks of 3 bits each (85*3=255)
    wire [1:0] partial_counts [0:84];

    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : popcount3_blocks
            popcount3 pc3 (
                .in(in[i*3 +: 3]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Now sum 85 partial counts (each 2 bits) to get total popcount (up to 255)
    // Max sum = 85 * 3 = 255, fits in 8 bits

    // Implement an adder tree summing pairs of 8-bit extended partial counts iteratively.
    // Extend partial_counts (2 bits) to 8 bits first for addition.

    // Level 0: extend to 8 bits
    wire [7:0] sums_level0 [0:84];
    generate
        for (i = 0; i < 85; i = i + 1) begin : extend_to_8
            assign sums_level0[i] = {6'b0, partial_counts[i]};
        end
    endgenerate

    // We build a function to sum arrays of variable size by pairs until one sum remains

    function automatic void adder_tree;
        input integer in_len;
        input wire [7:0] input_array [0:in_len-1];
        output reg [7:0] output_array [0:((in_len+1)/2)-1];
        integer j;
        begin
            j = 0;
            for (integer idx = 0; idx < in_len; idx = idx + 2) begin
                if (idx + 1 < in_len)
                    output_array[j] = input_array[idx] + input_array[idx+1];
                else
                    output_array[j] = input_array[idx]; // odd element forward
                j = j + 1;
            end
        end
    endfunction

    // Because SystemVerilog function with arrays and variables is not synthesizable easily,
    // we implement the adder tree explicitly using generate loops and intermediate wires.

    // We create successive layers until the final single sum is left.

    // To simplify, we manually unroll several levels.

    // Level 1: sum pairs of sums_level0 (85 inputs)
    // 43 pairs + 1 leftover

    wire [7:0] sums_level1 [0:42];
    genvar idx;
    generate
        for (idx = 0; idx < 42; idx = idx + 1) begin : level1_sum_pairs
            assign sums_level1[idx] = sums_level0[2*idx] + sums_level0[2*idx + 1];
        end
        // last odd element
        assign sums_level1[42] = sums_level0[84];
    endgenerate

    // Level 2: sum pairs of sums_level1 (43 inputs)
    // 21 pairs + 1 leftover

    wire [7:0] sums_level2 [0:21];
    generate
        for (idx = 0; idx < 21; idx = idx + 1) begin : level2_sum_pairs
            assign sums_level2[idx] = sums_level1[2*idx] + sums_level1[2*idx + 1];
        end
        assign sums_level2[21] = sums_level1[42];
    endgenerate

    // Level 3: sum pairs of sums_level2 (22 inputs)
    // 11 pairs (even number)

    wire [7:0] sums_level3 [0:10];
    generate
        for (idx = 0; idx < 11; idx = idx + 1) begin : level3_sum_pairs
            assign sums_level3[idx] = sums_level2[2*idx] + sums_level2[2*idx + 1];
        end
    endgenerate

    // Level 4: sum pairs of sums_level3 (11 inputs)
    // 5 pairs + 1 leftover

    wire [7:0] sums_level4 [0:5];
    generate
        for (idx = 0; idx < 5; idx = idx + 1) begin : level4_sum_pairs
            assign sums_level4[idx] = sums_level3[2*idx] + sums_level3[2*idx + 1];
        end
        assign sums_level4[5] = sums_level3[10];
    endgenerate

    // Level 5: sum pairs of sums_level4 (6 inputs)
    // 3 pairs

    wire [7:0] sums_level5 [0:2];
    generate
        for (idx = 0; idx < 3; idx = idx + 1) begin : level5_sum_pairs
            assign sums_level5[idx] = sums_level4[2*idx] + sums_level4[2*idx + 1];
        end
    endgenerate

    // Level 6: sum pairs of sums_level5 (3 inputs)
    // 1 pair + 1 leftover

    wire [7:0] sums_level6 [0:1];
    assign sums_level6[0] = sums_level5[0] + sums_level5[1];
    assign sums_level6[1] = sums_level5[2];

    // Level 7: sum final two

    assign out = sums_level6[0] + sums_level6[1];

endmodule