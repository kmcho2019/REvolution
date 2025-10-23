module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Parameters for flexible design
    parameter GROUP_SIZE = 4;
    parameter NUM_GROUPS = 64; // 255/4 = 63.75 -> 64 groups (last group padded)

    // Stage 1: 4-bit LUT-based population counts
    wire [2:0] partial_counts [0:NUM_GROUPS-1];
    
    genvar i;
    generate
        for (i = 0; i < NUM_GROUPS; i = i + 1) begin : LUT_COUNTS
            // Get current 4-bit group (pad last group with zeros)
            wire [3:0] group = (i*4+3 <= 254) ? in[i*4 +: 4] : 4'b0;
            
            // LUT-based population count for 4 bits
            assign partial_counts[i] = 
                (group == 4'b0000) ? 3'd0 :
                (group == 4'b0001) ? 3'd1 :
                (group == 4'b0010) ? 3'd1 :
                (group == 4'b0011) ? 3'd2 :
                (group == 4'b0100) ? 3'd1 :
                (group == 4'b0101) ? 3'd2 :
                (group == 4'b0110) ? 3'd2 :
                (group == 4'b0111) ? 3'd3 :
                (group == 4'b1000) ? 3'd1 :
                (group == 4'b1001) ? 3'd2 :
                (group == 4'b1010) ? 3'd2 :
                (group == 4'b1011) ? 3'd3 :
                (group == 4'b1100) ? 3'd2 :
                (group == 4'b1101) ? 3'd3 :
                (group == 4'b1110) ? 3'd3 : 3'd4;
        end
    endgenerate

    // Stage 2: Balanced adder tree (64 -> 32 -> 16 -> 8 -> 4 -> 2 -> 1)
    wire [7:0] sum_level1 [0:31];
    wire [7:0] sum_level2 [0:15];
    wire [7:0] sum_level3 [0:7];
    wire [7:0] sum_level4 [0:3];
    wire [7:0] sum_level5 [0:1];
    wire [7:0] final_sum;
    
    // Level 1: 64 -> 32
    generate
        for (i = 0; i < 32; i = i + 1) begin : LEVEL1
            assign sum_level1[i] = partial_counts[i*2] + partial_counts[i*2+1];
        end
    endgenerate
    
    // Level 2: 32 -> 16
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL2
            assign sum_level2[i] = sum_level1[i*2] + sum_level1[i*2+1];
        end
    endgenerate
    
    // Level 3: 16 -> 8
    generate
        for (i = 0; i < 8; i = i + 1) begin : LEVEL3
            assign sum_level3[i] = sum_level2[i*2] + sum_level2[i*2+1];
        end
    endgenerate
    
    // Level 4: 8 -> 4
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL4
            assign sum_level4[i] = sum_level3[i*2] + sum_level3[i*2+1];
        end
    endgenerate
    
    // Level 5: 4 -> 2
    generate
        for (i = 0; i < 2; i = i + 1) begin : LEVEL5
            assign sum_level5[i] = sum_level4[i*2] + sum_level4[i*2+1];
        end
    endgenerate
    
    // Final sum
    assign final_sum = sum_level5[0] + sum_level5[1];
    
    assign out = final_sum;

endmodule