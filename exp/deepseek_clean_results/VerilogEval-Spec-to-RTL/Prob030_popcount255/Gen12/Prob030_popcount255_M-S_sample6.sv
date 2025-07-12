module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in groups of 8 bits (32 groups)
    wire [3:0] partial_counts [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : COUNT_8BITS
            localparam start = i*8;
            wire [7:0] group = (start+7 <= 254) ? in[start +: 8] : 
                              {in[start +: 255-start], {(8-(255-start)){1'b0}}};
            assign partial_counts[i] = group[0] + group[1] + group[2] + group[3] + 
                                     group[4] + group[5] + group[6] + group[7];
        end
    endgenerate

    // Second level: Sum partial counts in two stages
    wire [7:0] sum_stage1 [0:15];
    wire [7:0] sum_stage2 [0:7];
    
    // Stage 1: Sum pairs of partial counts (16 adders)
    for (i = 0; i < 16; i = i + 1) begin : STAGE1
        assign sum_stage1[i] = partial_counts[2*i] + partial_counts[2*i+1];
    end

    // Stage 2: Sum pairs of stage1 results (8 adders)
    for (i = 0; i < 8; i = i + 1) begin : STAGE2
        assign sum_stage2[i] = sum_stage1[2*i] + sum_stage1[2*i+1];
    end

    // Final sum
    assign out = sum_stage2[0] + sum_stage2[1] + sum_stage2[2] + sum_stage2[3] +
                 sum_stage2[4] + sum_stage2[5] + sum_stage2[6] + sum_stage2[7];

endmodule