module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in groups of 8 bits (32 groups)
    wire [3:0] partial_counts [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BITS
            wire [7:0] group = in[i*8 +: 8];
            assign partial_counts[i] = group[0] + group[1] + group[2] + group[3] + 
                                     group[4] + group[5] + group[6] + group[7];
        end
        // Handle last partial group (7 bits)
        wire [6:0] last_group = in[248 +: 7];
        assign partial_counts[31] = last_group[0] + last_group[1] + last_group[2] + 
                                  last_group[3] + last_group[4] + last_group[5] + last_group[6];
    endgenerate

    // Second level: Sum partial counts in a binary tree
    wire [7:0] sum;
    
    // First stage: Sum pairs of 4-bit counts to 5-bit sums
    wire [4:0] stage1 [0:15];
    for (i = 0; i < 16; i = i + 1) begin : STAGE1
        assign stage1[i] = partial_counts[i*2] + partial_counts[i*2+1];
    end

    // Second stage: Sum pairs of 5-bit sums to 6-bit sums
    wire [5:0] stage2 [0:7];
    for (i = 0; i < 8; i = i + 1) begin : STAGE2
        assign stage2[i] = stage1[i*2] + stage1[i*2+1];
    end

    // Third stage: Sum pairs of 6-bit sums to 7-bit sums
    wire [6:0] stage3 [0:3];
    for (i = 0; i < 4; i = i + 1) begin : STAGE3
        assign stage3[i] = stage2[i*2] + stage2[i*2+1];
    end

    // Fourth stage: Sum pairs of 7-bit sums to 8-bit final sum
    assign sum = stage3[0] + stage3[1] + stage3[2] + stage3[3];

    assign out = sum;

endmodule