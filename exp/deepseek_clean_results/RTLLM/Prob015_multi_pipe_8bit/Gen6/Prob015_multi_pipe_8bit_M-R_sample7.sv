module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] stage1_a, stage1_b;
    reg [15:0] stage2_pp [0:7];
    reg [15:0] stage3_sum_low, stage3_sum_high;
    reg [15:0] stage4_result;
    
    // Enable pipeline
    reg [3:0] enable_pipe;

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    stage2_pp[i] <= 16'b0;
                end else if (enable_pipe[0]) begin
                    stage2_pp[i] <= (stage1_b[i] ? {8'b0, stage1_a} << i : 16'b0);
                end
            end
        end
    endgenerate

    // Summation tree
    wire [15:0] sum0 = stage2_pp[0] + stage2_pp[1];
    wire [15:0] sum1 = stage2_pp[2] + stage2_pp[3];
    wire [15:0] sum2 = stage2_pp[4] + stage2_pp[5];
    wire [15:0] sum3 = stage2_pp[6] + stage2_pp[7];
    wire [15:0] sum_low = sum0 + sum1;
    wire [15:0] sum_high = sum2 + sum3;

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear data pipeline
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage3_sum_low <= 16'b0;
            stage3_sum_high <= 16'b0;
            stage4_result <= 16'b0;
            
            // Clear enable pipeline
            enable_pipe <= 4'b0;
        end else begin
            // Stage 1: Input registers
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            
            // Stage 3: Intermediate sums
            stage3_sum_low <= sum_low;
            stage3_sum_high <= sum_high;
            
            // Stage 4: Final result
            stage4_result <= stage3_sum_low + stage3_sum_high;
            
            // Enable pipeline
            enable_pipe <= {enable_pipe[2:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = enable_pipe[3];
    assign mul_out = mul_en_out ? stage4_result : 16'b0;

endmodule