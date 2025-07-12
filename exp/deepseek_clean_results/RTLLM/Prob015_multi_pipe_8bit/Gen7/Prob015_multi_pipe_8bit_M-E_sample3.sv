module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline registers
    reg [2:0] en_pipeline;
    reg [15:0] stage1 [0:6];  // Stage 1 compression results
    reg [15:0] stage2 [0:3];  // Stage 2 compression results
    reg [15:0] final_result;  // Stage 3 final result

    // Generate all partial products
    wire [15:0] pp [0:7];
    generate
        genvar i;
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = mul_b[i] ? {8'b0, mul_a} << i : 16'b0;
        end
    endgenerate

    // Stage 1: 3:2 compression (Wallace Tree first level)
    wire [15:0] s1_cout [0:6];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipeline <= 3'b0;
            for (integer j=0; j<7; j=j+1) stage1[j] <= 16'b0;
        end else begin
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
            
            // First compression level (7 compressors)
            stage1[0] <= pp[0] ^ pp[1] ^ pp[2];
            s1_cout[0] <= (pp[0] & pp[1]) | (pp[0] & pp[2]) | (pp[1] & pp[2]);
            
            stage1[1] <= pp[3] ^ pp[4] ^ pp[5];
            s1_cout[1] <= (pp[3] & pp[4]) | (pp[3] & pp[5]) | (pp[4] & pp[5]);
            
            stage1[2] <= pp[6] ^ pp[7] ^ s1_cout[0];
            s1_cout[2] <= (pp[6] & pp[7]) | (pp[6] & s1_cout[0]) | (pp[7] & s1_cout[0]);
            
            // Remaining compressions (mix of 3:2 and 2:2)
            stage1[3] <= s1_cout[1] ^ s1_cout[2] ^ stage1[0];
            s1_cout[3] <= (s1_cout[1] & s1_cout[2]) | (s1_cout[1] & stage1[0]) | (s1_cout[2] & stage1[0]);
            
            stage1[4] <= stage1[1] ^ stage1[2] ^ stage1[3];
            s1_cout[4] <= (stage1[1] & stage1[2]) | (stage1[1] & stage1[3]) | (stage1[2] & stage1[3]);
            
            stage1[5] <= s1_cout[3] ^ s1_cout[4] ^ stage1[4];
            s1_cout[5] <= (s1_cout[3] & s1_cout[4]) | (s1_cout[3] & stage1[4]) | (s1_cout[4] & stage1[4]);
            
            stage1[6] <= s1_cout[5];
        end
    end

    // Stage 2: Further reduction
    wire [15:0] s2_cout [0:3];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (integer k=0; k<4; k=k+1) stage2[k] <= 16'b0;
        end else if (en_pipeline[0]) begin
            // Second compression level
            stage2[0] <= stage1[0] ^ stage1[1] ^ stage1[2];
            s2_cout[0] <= (stage1[0] & stage1[1]) | (stage1[0] & stage1[2]) | (stage1[1] & stage1[2]);
            
            stage2[1] <= stage1[3] ^ stage1[4] ^ stage1[5];
            s2_cout[1] <= (stage1[3] & stage1[4]) | (stage1[3] & stage1[5]) | (stage1[4] & stage1[5]);
            
            stage2[2] <= stage1[6] ^ s2_cout[0] ^ s2_cout[1];
            s2_cout[2] <= (stage1[6] & s2_cout[0]) | (stage1[6] & s2_cout[1]) | (s2_cout[0] & s2_cout[1]);
            
            stage2[3] <= s2_cout[2];
        end else begin
            for (integer k=0; k<4; k=k+1) stage2[k] <= 16'b0;
        end
    end

    // Stage 3: Final addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_result <= 16'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else if (en_pipeline[1]) begin
            // Final carry-propagate addition
            final_result <= stage2[0] + stage2[1] + stage2[2] + stage2[3];
            mul_en_out <= en_pipeline[2];
            mul_out <= en_pipeline[2] ? final_result : 16'b0;
        end else begin
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end
    end

endmodule