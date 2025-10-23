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
    reg [7:0] a_reg, b_reg;
    reg [15:0] stage1_sum, stage2_sum;
    reg [15:0] result_reg;
    reg [1:0] en_pipeline;  // Reduced to 2 stages

    // Gated partial products (optimized for power)
    wire [15:0] pp[0:7];
    assign pp[0] = {8'b0, b_reg[0] ? a_reg : 8'b0};
    assign pp[1] = {7'b0, (b_reg[1] ? a_reg : 8'b0), 1'b0};
    assign pp[2] = {6'b0, (b_reg[2] ? a_reg : 8'b0), 2'b0};
    assign pp[3] = {5'b0, (b_reg[3] ? a_reg : 8'b0), 3'b0};
    assign pp[4] = {4'b0, (b_reg[4] ? a_reg : 8'b0), 4'b0};
    assign pp[5] = {3'b0, (b_reg[5] ? a_reg : 8'b0), 5'b0};
    assign pp[6] = {2'b0, (b_reg[6] ? a_reg : 8'b0), 6'b0};
    assign pp[7] = {1'b0, (b_reg[7] ? a_reg : 8'b0), 7'b0};

    // Split additions for better timing
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp[4] + pp[5];
    wire [15:0] sum67 = pp[6] + pp[7];
    wire [15:0] sum_low = sum01 + sum23;
    wire [15:0] sum_high = sum45 + sum67;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            stage1_sum <= 16'b0;
            stage2_sum <= 16'b0;
            result_reg <= 16'b0;
            en_pipeline <= 2'b0;
        end else begin
            // Stage 1: Register inputs and first level sums
            a_reg <= mul_a;
            b_reg <= mul_b;
            stage1_sum <= sum_low + sum_high;  // Combine both sums in one stage
            
            // Stage 2: Final accumulation
            stage2_sum <= stage1_sum;
            result_reg <= stage2_sum;
            
            // Enable pipeline (matches data path)
            en_pipeline <= {en_pipeline[0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[1];
    assign mul_out = en_pipeline[1] ? result_reg : 16'b0;

endmodule