module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Stage 1: Process 4-bit chunks in parallel
    wire [11:0] stage1_remainders [0:3];
    wire [3:0] stage1_results [0:3];
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE1
            wire [11:0] partial_remainder = {4'b0, A[15-i*4 -:4], 4'b0};
            assign stage1_results[i] = partial_remainder[11:4] / B;
            assign stage1_remainders[i] = {4'b0, (partial_remainder[11:4] % B), A[15-i*4 -:4]};
        end
    endgenerate

    // Stage 2: Combine pairs of 4-bit results
    wire [7:0] stage2_remainders [0:1];
    wire [7:0] stage2_results [0:1];
    
    generate
        for (i = 0; i < 2; i = i + 1) begin : STAGE2
            wire [15:0] combined_remainder = {stage1_remainders[i*2][7:0], 
                                            stage1_remainders[i*2+1][7:0]};
            wire [7:0] partial_result = combined_remainder[15:8] / B;
            assign stage2_results[i] = {stage1_results[i*2], stage1_results[i*2+1]} + 
                                     {4'b0, partial_result};
            assign stage2_remainders[i] = combined_remainder[15:8] % B;
        end
    endgenerate

    // Final Stage: Combine all results
    wire [15:0] final_remainder = {stage2_remainders[0], stage2_remainders[1]};
    wire [7:0] final_correction = final_remainder[15:8] / B;
    
    assign result = {stage2_results[0], stage2_results[1]} + {12'b0, final_correction};
    assign odd = {8'b0, final_remainder[15:8] % B};

endmodule