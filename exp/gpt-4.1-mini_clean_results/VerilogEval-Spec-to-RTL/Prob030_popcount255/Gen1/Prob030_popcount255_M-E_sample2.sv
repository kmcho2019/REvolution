module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Function: popcount5 counts number of '1's in a 5-bit input
    function [2:0] popcount5;
        input [4:0] bits;
        integer k;
        begin
            popcount5 = 0;
            for (k = 0; k < 5; k = k + 1)
                popcount5 = popcount5 + bits[k];
        end
    endfunction

    // Function: popcount17 counts number of '1's in 17-bit input,
    // by splitting into three 5-bit parts + 1 bit, then summing partial counts
    function [4:0] popcount17; // max count 17 fits in 5 bits
        input [16:0] bits;
        reg [2:0] c0, c1, c2;
        reg       c3;
        reg [4:0] sum01;
        reg [4:0] sum012;
        begin
            c0 = popcount5(bits[4:0]);
            c1 = popcount5(bits[9:5]);
            c2 = popcount5(bits[14:10]);
            c3 = bits[16];
            sum01 = c0 + c1;
            sum012 = sum01 + c2;
            popcount17 = sum012 + c3;
        end
    endfunction

    // Step 1: Split 255 bits into 15 groups of 17 bits
    wire [4:0] popcnt_groups [14:0]; // 15 groups, each 5 bits to hold count max 17

    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : group17
            wire [16:0] slice = in[i*17 +: 17];
            assign popcnt_groups[i] = popcount17(slice);
        end
    endgenerate

    // Step 2: Sum the 15 counts via balanced adder tree

    // Level 1: sum pairs -> 7 sums + 1 leftover
    wire [5:0] sum_level1 [6:0]; // sums of two 5-bit values (max 17+17=34 => 6 bits)
    wire [4:0] leftover1 = popcnt_groups[14]; // last unpaired group

    generate
        for (i = 0; i < 7; i = i + 1) begin : level1
            assign sum_level1[i] = popcnt_groups[2*i] + popcnt_groups[2*i+1];
        end
    endgenerate

    // Level 2: sum pairs of level1 -> 3 sums + 1 leftover
    wire [6:0] sum_level2 [2:0]; // max 34+34=68 fits in 7 bits
    wire [5:0] leftover2 = sum_level1[6]; // last leftover from level1

    generate
        for (i = 0; i < 3; i = i + 1) begin : level2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i+1];
        end
    endgenerate

    // Level 3: sum pairs of level2 -> 1 sum + 1 leftover
    wire [7:0] sum_level3 [0:0]; // max 68+68=136 fits in 8 bits
    wire [6:0] leftover3 = sum_level2[2]; // last leftover from level2

    assign sum_level3[0] = sum_level2[0] + sum_level2[1];

    // Level 4: sum final leftovers and level3 sum
    // leftover3 (7 bits) + leftover2 (6 bits) + leftover1 (5 bits) + sum_level3[0] (8 bits)
    // max sum ~ 136 + 68 + 34 + 17 = 255 fits in 8 bits
    wire [8:0] total_sum;

    assign total_sum = sum_level3[0] + leftover3 + leftover2 + leftover1;

    assign out = total_sum[7:0]; // output final 8-bit population count

endmodule