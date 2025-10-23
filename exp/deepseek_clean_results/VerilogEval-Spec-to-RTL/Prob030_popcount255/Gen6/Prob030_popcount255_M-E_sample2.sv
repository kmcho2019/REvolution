module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Stage 1: Count '1's in 17-bit chunks (15 chunks)
    wire [3:0] group_counts [0:14];
    genvar i;
    generate
        for (i = 0; i < 15; i = i + 1) begin : GROUP_COUNTERS
            // Count '1's in each 17-bit group
            wire [16:0] group = in[i*17 +: 17];
            assign group_counts[i] = group[0] + group[1] + group[2] + group[3] + 
                                   group[4] + group[5] + group[6] + group[7] + 
                                   group[8] + group[9] + group[10] + group[11] + 
                                   group[12] + group[13] + group[14] + group[15] + 
                                   group[16];
        end
    endgenerate

    // Stage 2: Wallace tree reduction of 15 counts
    wire [7:0] sum1_0 = group_counts[0] + group_counts[1] + group_counts[2];
    wire [7:0] sum1_1 = group_counts[3] + group_counts[4] + group_counts[5];
    wire [7:0] sum1_2 = group_counts[6] + group_counts[7] + group_counts[8];
    wire [7:0] sum1_3 = group_counts[9] + group_counts[10] + group_counts[11];
    wire [7:0] sum1_4 = group_counts[12] + group_counts[13] + group_counts[14];

    wire [7:0] sum2_0 = sum1_0 + sum1_1;
    wire [7:0] sum2_1 = sum1_2 + sum1_3;
    
    wire [7:0] sum3_0 = sum2_0 + sum2_1;
    
    assign out = sum3_0 + sum1_4;

endmodule