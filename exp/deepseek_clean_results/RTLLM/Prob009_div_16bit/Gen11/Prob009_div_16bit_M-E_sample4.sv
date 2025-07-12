module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Stage 1: Compare with B*128, B*64, B*32, B*16
    wire [15:0] scaled_B_128 = {B, 8'b0};
    wire [15:0] scaled_B_64 = {1'b0, B, 7'b0};
    wire [15:0] scaled_B_32 = {2'b0, B, 6'b0};
    wire [15:0] scaled_B_16 = {3'b0, B, 5'b0};
    
    wire [3:0] cmp_stage1;
    assign cmp_stage1[3] = (A >= scaled_B_128);
    assign cmp_stage1[2] = (A >= scaled_B_64);
    assign cmp_stage1[1] = (A >= scaled_B_32);
    assign cmp_stage1[0] = (A >= scaled_B_16);
    
    // Determine MSBs of quotient
    wire [3:0] q_high;
    assign q_high = {cmp_stage1[3], 
                    cmp_stage1[2] & ~cmp_stage1[3],
                    cmp_stage1[1] & ~(|cmp_stage1[3:2]),
                    cmp_stage1[0] & ~(|cmp_stage1[3:1])};
    
    // Calculate partial remainder
    wire [15:0] partial_rem;
    assign partial_rem = A - (q_high[3] ? scaled_B_128 :
                            q_high[2] ? scaled_B_64 :
                            q_high[1] ? scaled_B_32 :
                            q_high[0] ? scaled_B_16 : 16'b0);
    
    // Stage 2: Compare with B*8 to B*1
    wire [15:0] scaled_B_8 = {4'b0, B, 4'b0};
    wire [15:0] scaled_B_4 = {5'b0, B, 3'b0};
    wire [15:0] scaled_B_2 = {6'b0, B, 2'b0};
    wire [15:0] scaled_B_1 = {7'b0, B, 1'b0};
    
    wire [3:0] cmp_stage2;
    assign cmp_stage2[3] = (partial_rem >= scaled_B_8);
    assign cmp_stage2[2] = (partial_rem >= scaled_B_4);
    assign cmp_stage2[1] = (partial_rem >= scaled_B_2);
    assign cmp_stage2[0] = (partial_rem >= scaled_B_1);
    
    // Determine LSBs of quotient
    wire [3:0] q_low;
    assign q_low = {cmp_stage2[3], 
                   cmp_stage2[2] & ~cmp_stage2[3],
                   cmp_stage2[1] & ~(|cmp_stage2[3:2]),
                   cmp_stage2[0] & ~(|cmp_stage2[3:1])};
    
    // Final quotient assembly
    assign result = {q_high, q_low, 8'b0};
    
    // Final remainder calculation
    wire [15:0] final_partial;
    assign final_partial = partial_rem - (q_low[3] ? scaled_B_8 :
                                        q_low[2] ? scaled_B_4 :
                                        q_low[1] ? scaled_B_2 :
                                        q_low[0] ? scaled_B_1 : 16'b0);
    
    assign odd = final_partial[7:0];

endmodule