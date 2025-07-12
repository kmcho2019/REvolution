module popcount17 (
    input  [16:0] in,
    output [5:0] out  // max 17 ones fits in 6 bits
);
    // Break 17 bits into four 4-bit groups + 1 bit
    wire [3:0] group0 = in[3:0];
    wire [3:0] group1 = in[7:4];
    wire [3:0] group2 = in[11:8];
    wire [3:0] group3 = in[15:12];
    wire       leftover = in[16];

    // Count ones in 4-bit groups via sum of bits
    wire [2:0] sum0 = group0[0] + group0[1] + group0[2] + group0[3]; 
    wire [2:0] sum1 = group1[0] + group1[1] + group1[2] + group1[3];
    wire [2:0] sum2 = group2[0] + group2[1] + group2[2] + group2[3];
    wire [2:0] sum3 = group3[0] + group3[1] + group3[2] + group3[3];

    // Sum these 3-bit results plus leftover bit in a balanced manner
    wire [4:0] sum01 = sum0 + sum1;      // max 8 bits
    wire [4:0] sum23 = sum2 + sum3;      // max 8 bits
    wire [5:0] sum_all = sum01 + sum23;  // max 16 bits
    assign out = sum_all + leftover;      // add leftover bit (0 or 1)
endmodule

module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Define a parameterized function to reduce an array of values with a balanced adder tree
    // This recursive function reduces input count to 1 summation
    // Input width and output width are parameters
    // This function returns the sum of an array of inputs of width W_IN and count N
    function automatic [7:0] popcount_tree_sum;
        input integer N;
        input [7:0] values [0:254]; // max input count limited to 255
        integer half, i;
        reg [7:0] sums [0:254];
        begin
            if (N == 1) begin
                popcount_tree_sum = values[0];
            end else begin
                half = N >> 1;
                for (i = 0; i < half; i = i + 1) begin
                    sums[i] = values[2*i] + values[2*i + 1];
                end
                if (N % 2 == 1) begin
                    sums[half] = values[N-1];
                    popcount_tree_sum = popcount_tree_sum(half+1, sums);
                end else begin
                    popcount_tree_sum = popcount_tree_sum(half, sums);
                end
            end
        end
    endfunction

    // Create partial sums from 15 blocks of 17 bits using popcount17
    wire [5:0] partial_counts [14:0];
    genvar gi;
    generate
        for (gi=0; gi<15; gi=gi+1) begin : popcount17_blocks
            popcount17 pc17 (
                .in(in[gi*17 +: 17]),
                .out(partial_counts[gi])
            );
        end
    endgenerate

    // Extend partial counts from 6 bits to 8 bits for final summation
    wire [7:0] partial_counts_ext [14:0];
    generate
        for (gi=0; gi<15; gi=gi+1) begin
            assign partial_counts_ext[gi] = {2'b00, partial_counts[gi]};
        end
    endgenerate

    // Use a combinational always block with local variables to call the recursive function
    // or assign via a continuous assignment using a helper variable
    // Since functions can't be directly used in continuous assignment with array inputs,
    // instantiate a wire with the sum by calling the function inside a generate-for block.

    // Use an intermediate wire to hold the sum result
    wire [7:0] total_popcount;

    // Because direct call of the function with arrays is tricky in Verilog-2001, implement 
    // the recursive adder tree manually here in the same style but cleaner.

    // Level 1: sum pairs of partial_counts_ext (7 pairs) + one leftover
    wire [7:0] sum_level1 [7:0];
    generate
        for (gi = 0; gi < 7; gi = gi + 1) begin : level1_sum
            assign sum_level1[gi] = partial_counts_ext[2*gi] + partial_counts_ext[2*gi + 1];
        end
        assign sum_level1[7] = partial_counts_ext[14]; // leftover
    endgenerate

    // Level 2: sum pairs of sum_level1 outputs (4 pairs)
    wire [7:0] sum_level2 [3:0];
    generate
        for (gi = 0; gi < 4; gi = gi + 1) begin : level2_sum
            assign sum_level2[gi] = sum_level1[2*gi] + sum_level1[2*gi + 1];
        end
    endgenerate

    // Level 3: sum pairs of sum_level2 outputs (2 pairs)
    wire [7:0] sum_level3 [1:0];
    generate
        for (gi = 0; gi < 2; gi = gi + 1) begin : level3_sum
            assign sum_level3[gi] = sum_level2[2*gi] + sum_level2[2*gi + 1];
        end
    endgenerate

    // Level 4: final sum of sum_level3 outputs
    assign out = sum_level3[0] + sum_level3[1];

endmodule