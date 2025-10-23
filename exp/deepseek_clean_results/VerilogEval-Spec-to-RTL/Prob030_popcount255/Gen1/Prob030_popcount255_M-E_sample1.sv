module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Stage 1: Count 1s in groups of 3 bits (85 groups)
    wire [6:0] stage1 [0:84];  // 85 groups, each needs 2 bits (but using 7 bits for easier indexing)
    
    genvar i;
    generate
        // Count for complete groups of 3 bits
        for (i = 0; i < 85; i = i + 1) begin : stage1_gen
            localparam start = i*3;
            if (start+2 <= 254) begin
                assign stage1[i][1:0] = in[start] + in[start+1] + in[start+2];
            end
        end
        
        // Handle the last incomplete group (bits 255-257 don't exist, but 255 is our last bit)
        assign stage1[84][1:0] = in[254];  // Only bit 254 remains
    endgenerate

    // Stage 2: Combine counts from stage1 (85 counts -> 43 counts)
    wire [6:0] stage2 [0:42];
    generate
        for (i = 0; i < 42; i = i + 1) begin : stage2_gen
            assign stage2[i] = stage1[2*i] + stage1[2*i+1];
        end
        // Handle the last odd count
        assign stage2[42] = stage1[84];
    endgenerate

    // Stage 3: Combine counts from stage2 (43 counts -> 22 counts)
    wire [6:0] stage3 [0:21];
    generate
        for (i = 0; i < 21; i = i + 1) begin : stage3_gen
            assign stage3[i] = stage2[2*i] + stage2[2*i+1];
        end
        // Handle the last odd count
        assign stage3[21] = stage2[42];
    endgenerate

    // Stage 4: Combine counts from stage3 (22 counts -> 11 counts)
    wire [6:0] stage4 [0:10];
    generate
        for (i = 0; i < 10; i = i + 1) begin : stage4_gen
            assign stage4[i] = stage3[2*i] + stage3[2*i+1];
        end
        // Handle the last odd count
        assign stage4[10] = stage3[20] + stage3[21];  // Combine last two
    endgenerate

    // Stage 5: Combine counts from stage4 (11 counts -> 6 counts)
    wire [6:0] stage5 [0:5];
    generate
        for (i = 0; i < 5; i = i + 1) begin : stage5_gen
            assign stage5[i] = stage4[2*i] + stage4[2*i+1];
        end
        // Handle the last odd count
        assign stage5[5] = stage4[10];
    endgenerate

    // Stage 6: Combine counts from stage5 (6 counts -> 3 counts)
    wire [6:0] stage6 [0:2];
    generate
        for (i = 0; i < 3; i = i + 1) begin : stage6_gen
            assign stage6[i] = stage5[2*i] + ((2*i+1 < 6) ? stage5[2*i+1] : 0);
        end
    endgenerate

    // Final stage: Combine the last 3 counts
    assign out = stage6[0] + stage6[1] + stage6[2];

endmodule