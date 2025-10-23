module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Stage 1: Carry-save reduction of 3-bit groups
    wire [1:0] sum [0:84];
    wire [1:0] carry [0:84];
    
    genvar i;
    generate
        for (i = 0; i < 85; i = i + 1) begin : csa_stage1
            localparam start = i*3;
            wire [2:0] bits = (start+2 <= 254) ? in[start +: 3] : 
                             {in[start], in[start+1], 1'b0};
            
            // Carry-save addition of 3 bits
            assign sum[i] = bits[0] + bits[1] + bits[2];
            assign carry[i] = {bits[0] & bits[1], 1'b0};
        end
    endgenerate

    // Stage 2: Logarithmic carry-save reduction
    wire [3:0] stage2_sum [0:28];
    wire [3:0] stage2_carry [0:28];
    
    generate
        for (i = 0; i < 28; i = i + 1) begin : csa_stage2
            // Process 3 groups at a time
            wire [3:0] s1 = sum[i*3];
            wire [3:0] s2 = sum[i*3+1];
            wire [3:0] s3 = sum[i*3+2];
            wire [3:0] c1 = carry[i*3];
            wire [3:0] c2 = carry[i*3+1];
            wire [3:0] c3 = carry[i*3+2];
            
            assign stage2_sum[i] = s1 + s2 + s3;
            assign stage2_carry[i] = {((s1 & s2) | (s1 & s3) | (s2 & s3)), 1'b0} + 
                                    c1 + c2 + c3;
        end
        // Handle leftover group
        assign stage2_sum[28] = sum[84] + carry[84];
        assign stage2_carry[28] = 0;
    endgenerate

    // Stage 3: Final carry-save reduction
    wire [5:0] stage3_sum [0:9];
    wire [5:0] stage3_carry [0:9];
    
    generate
        for (i = 0; i < 9; i = i + 1) begin : csa_stage3
            // Process 3 groups at a time
            wire [5:0] s1 = stage2_sum[i*3];
            wire [5:0] s2 = stage2_sum[i*3+1];
            wire [5:0] s3 = stage2_sum[i*3+2];
            wire [5:0] c1 = stage2_carry[i*3];
            wire [5:0] c2 = stage2_carry[i*3+1];
            wire [5:0] c3 = stage2_carry[i*3+2];
            
            assign stage3_sum[i] = s1 + s2 + s3;
            assign stage3_carry[i] = {((s1 & s2) | (s1 & s3) | (s2 & s3)), 1'b0} + 
                                     c1 + c2 + c3;
        end
        // Handle leftover group
        assign stage3_sum[9] = stage2_sum[27] + stage2_sum[28] + 
                              stage2_carry[27] + stage2_carry[28];
        assign stage3_carry[9] = 0;
    endgenerate

    // Final addition using carry-lookahead
    wire [7:0] total_sum = 0;
    generate
        for (i = 0; i < 10; i = i + 1) begin : final_adder
            assign total_sum = total_sum + stage3_sum[i] + stage3_carry[i];
        end
    endgenerate

    assign out = total_sum;

endmodule