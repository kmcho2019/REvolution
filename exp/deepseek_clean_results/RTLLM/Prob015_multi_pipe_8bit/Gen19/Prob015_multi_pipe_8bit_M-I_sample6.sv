module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Parameters for pipeline stages
    parameter PIPELINE_DEPTH = 4;

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp_reg [0:1];  // Combined low/high partial sums
    reg [15:0] sum_reg;
    reg [15:0] result_reg;
    reg [PIPELINE_DEPTH-1:0] en_pipeline;

    // Clock-gated partial products
    wire [15:0] pp [0:7];
    assign pp[0] = {8'b0, (b_reg[0]) ? a_reg : 8'b0};
    assign pp[1] = {7'b0, (b_reg[1]) ? a_reg : 8'b0, 1'b0};
    assign pp[2] = {6'b0, (b_reg[2]) ? a_reg : 8'b0, 2'b0};
    assign pp[3] = {5'b0, (b_reg[3]) ? a_reg : 8'b0, 3'b0};
    assign pp[4] = {4'b0, (b_reg[4]) ? a_reg : 8'b0, 4'b0};
    assign pp[5] = {3'b0, (b_reg[5]) ? a_reg : 8'b0, 5'b0};
    assign pp[6] = {2'b0, (b_reg[6]) ? a_reg : 8'b0, 6'b0};
    assign pp[7] = {1'b0, (b_reg[7]) ? a_reg : 8'b0, 7'b0};

    // Optimized adder tree (split into more stages)
    wire [15:0] sum_stage1_0 = pp[0] + pp[1];
    wire [15:0] sum_stage1_1 = pp[2] + pp[3];
    wire [15:0] sum_stage1_2 = pp[4] + pp[5];
    wire [15:0] sum_stage1_3 = pp[6] + pp[7];
    
    wire [15:0] sum_stage2_0 = sum_stage1_0 + sum_stage1_1;
    wire [15:0] sum_stage2_1 = sum_stage1_2 + sum_stage1_3;

    wire [15:0] final_sum = sum_stage2_0 + sum_stage2_1;

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            pp_reg[0] <= 16'b0;
            pp_reg[1] <= 16'b0;
            sum_reg <= 16'b0;
            result_reg <= 16'b0;
            en_pipeline <= {PIPELINE_DEPTH{1'b0}};
        end else begin
            // Stage 1: Register inputs
            a_reg <= mul_a;
            b_reg <= mul_b;

            // Stage 2: Register first level sums
            pp_reg[0] <= sum_stage2_0;
            pp_reg[1] <= sum_stage2_1;

            // Stage 3: Register intermediate sum
            sum_reg <= pp_reg[0] + pp_reg[1];

            // Stage 4: Register final result
            result_reg <= sum_reg;

            // Enable signal pipeline
            en_pipeline <= {en_pipeline[PIPELINE_DEPTH-2:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[PIPELINE_DEPTH-1];
    assign mul_out = en_pipeline[PIPELINE_DEPTH-1] ? result_reg : 16'b0;

endmodule