module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First level: Count 1s in 8-bit chunks (3-bit results)
    wire [2:0] chunk_counts [0:31];
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : COUNT_8BIT
            assign chunk_counts[i] = in[i*8+7] + in[i*8+6] + in[i*8+5] + in[i*8+4] +
                                   in[i*8+3] + in[i*8+2] + in[i*8+1] + in[i*8];
        end
        // Last chunk has 7 bits
        assign chunk_counts[31] = in[254] + in[253] + in[252] + in[251] +
                                in[250] + in[249] + in[248];
    endgenerate

    // Second level: Sum pairs of chunks (4-bit results)
    wire [3:0] stage1_counts [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1
            assign stage1_counts[i] = chunk_counts[i*2] + chunk_counts[i*2+1];
        end
    endgenerate

    // Third level: Sum pairs of stage1 (5-bit results)
    wire [4:0] stage2_counts [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : STAGE2
            assign stage2_counts[i] = stage1_counts[i*2] + stage1_counts[i*2+1];
        end
    endgenerate

    // Fourth level: Sum pairs of stage2 (6-bit results)
    wire [5:0] stage3_counts [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE3
            assign stage3_counts[i] = stage2_counts[i*2] + stage2_counts[i*2+1];
        end
    endgenerate

    // Fifth level: Sum pairs of stage3 (7-bit results)
    wire [6:0] stage4_counts [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : STAGE4
            assign stage4_counts[i] = stage3_counts[i*2] + stage3_counts[i*2+1];
        end
    endgenerate

    // Final sum (8-bit result)
    assign out = stage4_counts[0] + stage4_counts[1];

endmodule