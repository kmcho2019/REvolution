module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // First, split input into 17 groups of 15 bits (except last group which is 0-padded)
    // Sum each 15-bit group to a 4-bit partial count
    // Then sum these 17 partial counts in a tree of adders to produce final 8-bit count

    // Partial sums: 17 groups * 15 bits = 255 bits total
    wire [3:0] group_sum [0:16];

    genvar i, j;

    // Function to sum up to 15 bits in a group
    function [3:0] popcount15;
        input [14:0] bits;
        integer k;
        reg [7:0] temp; // Enough bits to hold sums up to 15
        begin
            temp = 0;
            for (k=0; k<15; k=k+1) begin
                temp = temp + bits[k];
            end
            popcount15 = temp[3:0]; // max 15 fits in 4 bits
        end
    endfunction

    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_groups
            // Each group: bits [i*15 +: 15]
            assign group_sum[i] = popcount15(in[i*15 +: 15]);
        end
    endgenerate

    // The last group covers the remaining 15 bits (15*16=240, remaining 15 bits from 240 to 254)
    // Last 15 bits: in[240 +: 15]
    assign group_sum[16] = popcount15(in[240 +: 15]);

    // Now sum the 17 partial sums (each 4 bits) into final 8-bit output
    // We implement this as a balanced adder tree

    // Level 1: Sum groups in pairs, result 5 bits wide (max sum 2*15=30)
    wire [4:0] sum_level1 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_level1
            assign sum_level1[i] = group_sum[2*i] + group_sum[2*i + 1];
        end
    endgenerate
    // One leftover group_sum[16] (4 bits), treated as a single operand

    // Level 2: Sum pairs of sum_level1 (5 bits each), results 6 bits (max 30+30=60)
    wire [5:0] sum_level2 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_level2
            assign sum_level2[i] = sum_level1[2*i] + sum_level1[2*i + 1];
        end
    endgenerate

    // Level 3: Sum pairs of sum_level2 (6 bits each), results 7 bits (max 60+60=120)
    wire [6:0] sum_level3 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_level3
            assign sum_level3[i] = sum_level2[2*i] + sum_level2[2*i + 1];
        end
    endgenerate

    // Level 4: Sum sum_level3[0] + sum_level3[1], 7 bits each, result 8 bits (max 120+120=240)
    wire [7:0] sum_level4;
    assign sum_level4 = sum_level3[0] + sum_level3[1];

    // Add the leftover group_sum[16] (4 bits) to sum_level4 (8 bits), result 8 bits max 240+15=255
    assign out = sum_level4 + group_sum[16];

endmodule