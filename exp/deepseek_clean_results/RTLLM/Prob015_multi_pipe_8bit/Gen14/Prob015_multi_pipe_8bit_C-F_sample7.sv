module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage registers
    reg [7:0] stage1_a, stage1_b;
    reg [15:0] stage2_sum_low, stage2_sum_high;
    reg [15:0] stage3_result;
    
    // Enable pipeline
    reg [2:0] en_pipeline;

    // Optimized partial product generation
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = (mul_en_in & stage1_b[i]) ? ({8'b0, stage1_a} << i) : 16'b0;
        end
    endgenerate

    // Balanced adder tree
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp[4] + pp[5];
    wire [15:0] sum67 = pp[6] + pp[7];
    wire [15:0] sum_low = sum01 + sum23;
    wire [15:0] sum_high = sum45 + sum67;

    // Stage 1: Input registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
        end else if (mul_en_in) begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
        end
    end

    // Stage 2: Partial sum calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum_low <= 16'b0;
            stage2_sum_high <= 16'b0;
        end else if (en_pipeline[0]) begin
            stage2_sum_low <= sum_low;
            stage2_sum_high <= sum_high;
        end
    end

    // Stage 3: Final result
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_result <= 16'b0;
        end else if (en_pipeline[1]) begin
            stage3_result <= stage2_sum_low + stage2_sum_high;
        end
    end

    // Enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipeline <= 3'b0;
        end else begin
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[2];
    assign mul_out = en_pipeline[2] ? stage3_result : 16'b0;

endmodule