module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // First stage: count 1s in 3-bit groups (85 groups total)
    wire [6:0] stage1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : stage1_counters
            if (i < 84) begin
                assign stage1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
            end else begin
                // Last group has only 3 bits (255 = 84*3 + 3)
                assign stage1[i] = in[i*3] + in[i*3+1] + in[i*3+2];
            end
        end
    endgenerate

    // Second stage: sum the stage1 counts in pairs (43 groups)
    wire [7:0] stage2 [0:42];
    generate
        for (i = 0; i < 42; i = i + 1) begin : stage2_adders
            assign stage2[i] = stage1[i*2] + stage1[i*2+1];
        end
        // Last group has 1 element left (85 = 42*2 + 1)
        assign stage2[42] = stage1[84];
    endgenerate

    // Third stage: sum the stage2 counts in pairs (22 groups)
    wire [7:0] stage3 [0:21];
    generate
        for (i = 0; i < 21; i = i + 1) begin : stage3_adders
            assign stage3[i] = stage2[i*2] + stage2[i*2+1];
        end
        // Last group has 1 element left (43 = 21*2 + 1)
        assign stage3[21] = stage2[42];
    endgenerate

    // Fourth stage: sum the stage3 counts in pairs (11 groups)
    wire [7:0] stage4 [0:10];
    generate
        for (i = 0; i < 10; i = i + 1) begin : stage4_adders
            assign stage4[i] = stage3[i*2] + stage3[i*2+1];
        end
        // Last group has 1 element left (22 = 10*2 + 2)
        assign stage4[10] = stage3[20] + stage3[21];
    endgenerate

    // Fifth stage: sum the stage4 counts in pairs (6 groups)
    wire [7:0] stage5 [0:5];
    generate
        for (i = 0; i < 5; i = i + 1) begin : stage5_adders
            assign stage5[i] = stage4[i*2] + stage4[i*2+1];
        end
        // Last group has 1 element left (11 = 5*2 + 1)
        assign stage5[5] = stage4[10];
    endgenerate

    // Sixth stage: sum the stage5 counts in pairs (3 groups)
    wire [7:0] stage6 [0:2];
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage6_adders
            assign stage6[i] = stage5[i*2] + stage5[i*2+1];
        end
        // Last group has 1 element left (6 = 2*2 + 2)
        assign stage6[2] = stage5[4] + stage5[5];
    endgenerate

    // Seventh stage: sum the stage6 counts in pairs (2 groups)
    wire [7:0] stage7 [0:1];
    assign stage7[0] = stage6[0] + stage6[1];
    assign stage7[1] = stage6[2];

    // Final addition
    assign out = stage7[0] + stage7[1];

endmodule