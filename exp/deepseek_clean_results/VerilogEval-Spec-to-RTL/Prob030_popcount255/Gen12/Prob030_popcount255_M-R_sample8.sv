module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in groups of 4 bits (64 groups)
    wire [2:0] partial_counts [0:63];
    
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : COUNT_4BITS
            localparam start = i*4;
            wire [3:0] group = (start+3 <= 254) ? in[start +: 4] : 
                               {in[start], in[start+1], in[start+2], 1'b0};  // Handle last partial group
            assign partial_counts[i] = group[0] + group[1] + group[2] + group[3];
        end
    endgenerate

    // Handle remaining 3 bits
    wire [2:0] last_group = {in[252], in[253], in[254]};
    wire [2:0] last_count = last_group[0] + last_group[1] + last_group[2];

    // Second level: Binary tree summation
    // First stage: Sum pairs of partial counts (32 adders)
    wire [3:0] stage1 [0:31];
    generate
        for (i = 0; i < 32; i = i + 1) begin : STAGE1
            assign stage1[i] = partial_counts[2*i] + partial_counts[2*i+1];
        end
    endgenerate

    // Second stage: Sum pairs of stage1 results (16 adders)
    wire [4:0] stage2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE2
            assign stage2[i] = stage1[2*i] + stage1[2*i+1];
        end
    endgenerate

    // Third stage: Sum pairs of stage2 results (8 adders)
    wire [5:0] stage3 [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : STAGE3
            assign stage3[i] = stage2[2*i] + stage2[2*i+1];
        end
    endgenerate

    // Fourth stage: Sum pairs of stage3 results (4 adders)
    wire [6:0] stage4 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE4
            assign stage4[i] = stage3[2*i] + stage3[2*i+1];
        end
    endgenerate

    // Fifth stage: Sum pairs of stage4 results (2 adders)
    wire [7:0] stage5 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : STAGE5
            assign stage5[i] = stage4[2*i] + stage4[2*i+1];
        end
    endgenerate

    // Final sum including the last 3 bits
    assign out = stage5[0] + stage5[1] + last_count;

endmodule