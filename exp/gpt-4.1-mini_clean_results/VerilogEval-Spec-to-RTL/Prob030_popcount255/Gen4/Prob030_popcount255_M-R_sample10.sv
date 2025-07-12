module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Function to compute popcount for up to 17 bits using a balanced adder tree
    function [5:0] popcount17_func;
        input [16:0] bits;
        reg [3:0] pop4_0, pop4_1, pop4_2, pop4_3;
        reg [5:0] sum_4pop4;
        integer i;
        begin
            // popcount4 function: counts number of ones in 4 bits
            function [3:0] popcount4_func;
                input [3:0] val;
                integer j;
                begin
                    popcount4_func = 0;
                    for (j = 0; j < 4; j = j + 1)
                        popcount4_func = popcount4_func + val[j];
                end
            endfunction

            pop4_0 = popcount4_func(bits[3:0]);
            pop4_1 = popcount4_func(bits[7:4]);
            pop4_2 = popcount4_func(bits[11:8]);
            pop4_3 = popcount4_func(bits[15:12]);

            sum_4pop4 = pop4_0 + pop4_1 + pop4_2 + pop4_3;
            // add last bit bits[16]
            popcount17_func = sum_4pop4 + bits[16];
        end
    endfunction

    // Array to hold 15 partial popcounts for each 17-bit block
    wire [5:0] partial_counts [0:14];

    genvar idx;
    generate
        for (idx = 0; idx < 15; idx = idx + 1) begin : popcount_blocks
            // Assign partial popcount using function
            assign partial_counts[idx] = popcount17_func(in[idx*17 +: 17]);
        end
    endgenerate

    // Function to sum array elements in a balanced adder tree fashion
    function [7:0] balanced_sum_15;
        input [5:0] counts [0:14];
        reg [7:0] level1 [0:7];
        reg [7:0] level2 [0:3];
        reg [7:0] level3 [0:1];
        integer i;
        begin
            // Level 1: sum pairs of counts (7 pairs), plus last one copied
            for (i = 0; i < 7; i = i + 1)
                level1[i] = {2'b00, counts[2*i]} + {2'b00, counts[2*i + 1]};
            level1[7] = {2'b00, counts[14]};

            // Level 2: sum pairs of level1 (4 sums)
            for (i = 0; i < 4; i = i + 1)
                level2[i] = level1[2*i] + level1[2*i + 1];

            // Level 3: sum pairs of level2 (2 sums)
            for (i = 0; i < 2; i = i + 1)
                level3[i] = level2[2*i] + level2[2*i + 1];

            // Level 4: final sum
            balanced_sum_15 = level3[0] + level3[1];
        end
    endfunction

    assign out = balanced_sum_15(partial_counts);

endmodule