module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Stage 1: 3-bit population counts (85 counts)
    wire [1:0] stage1 [0:84];
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : stage1_counts
            // Each 3-bit window covers bits [3i : 3i+2]
            // Last window covers bits [252:254] (3 bits)
            wire [2:0] window;
            assign window = (i < 85) ? in[3*i +: 3] : 3'b0;
            
            // 3-bit population count LUT
            assign stage1[i] = 
                (window == 3'b000) ? 2'd0 :
                (window == 3'b001 || window == 3'b010 || window == 3'b100) ? 2'd1 :
                (window == 3'b011 || window == 3'b101 || window == 3'b110) ? 2'd2 :
                2'd3;
        end
    endgenerate

    // Stage 2: First level of adder tree (43 adders)
    wire [2:0] stage2 [0:42];
    generate
        for (i = 0; i < 42; i = i + 1) begin : stage2_adders
            assign stage2[i] = stage1[2*i] + stage1[2*i+1];
        end
        // Handle the odd case (85 inputs -> 42 pairs + 1 leftover)
        assign stage2[42] = {1'b0, stage1[84]};
    endgenerate

    // Stage 3: Second level of adder tree (22 adders)
    wire [3:0] stage3 [0:21];
    generate
        for (i = 0; i < 21; i = i + 1) begin : stage3_adders
            assign stage3[i] = stage2[2*i] + stage2[2*i+1];
        end
        // Handle leftover
        assign stage3[21] = {2'b00, stage2[42]};
    endgenerate

    // Stage 4: Third level of adder tree (11 adders)
    wire [4:0] stage4 [0:10];
    generate
        for (i = 0; i < 10; i = i + 1) begin : stage4_adders
            assign stage4[i] = stage3[2*i] + stage3[2*i+1];
        end
        // Handle leftover
        assign stage4[10] = {1'b0, stage3[21]};
    endgenerate

    // Stage 5: Fourth level of adder tree (6 adders)
    wire [5:0] stage5 [0:5];
    generate
        for (i = 0; i < 5; i = i + 1) begin : stage5_adders
            assign stage5[i] = stage4[2*i] + stage4[2*i+1];
        end
        // Handle leftover
        assign stage5[5] = {2'b00, stage4[10]};
    endgenerate

    // Stage 6: Fifth level of adder tree (3 adders)
    wire [6:0] stage6 [0:2];
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage6_adders
            assign stage6[i] = stage5[2*i] + stage5[2*i+1];
        end
        // Handle leftover
        assign stage6[2] = {1'b0, stage5[4]};
    endgenerate

    // Stage 7: Sixth level of adder tree (2 adders)
    wire [7:0] stage7 [0:1];
    assign stage7[0] = stage6[0] + stage6[1];
    assign stage7[1] = {1'b0, stage6[2]};

    // Final addition
    assign out = stage7[0] + stage7[1];

endmodule