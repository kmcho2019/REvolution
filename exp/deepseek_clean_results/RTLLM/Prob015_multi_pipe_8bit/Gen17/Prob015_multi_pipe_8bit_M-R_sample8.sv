module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage 1 registers (input sampling)
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;

    // Pipeline stage 2 registers (partial products)
    reg [15:0] stage2_pp0, stage2_pp1, stage2_pp2, stage2_pp3;
    reg [15:0] stage2_pp4, stage2_pp5, stage2_pp6, stage2_pp7;
    reg stage2_en;

    // Pipeline stage 3 registers (final result)
    reg [15:0] stage3_result;
    reg stage3_en;

    // Generate partial products using continuous assignment
    wire [15:0] pp0 = {8'b0, stage1_b[0] ? stage1_a : 8'b0};
    wire [15:0] pp1 = {7'b0, stage1_b[1] ? stage1_a : 8'b0, 1'b0};
    wire [15:0] pp2 = {6'b0, stage1_b[2] ? stage1_a : 8'b0, 2'b0};
    wire [15:0] pp3 = {5'b0, stage1_b[3] ? stage1_a : 8'b0, 3'b0};
    wire [15:0] pp4 = {4'b0, stage1_b[4] ? stage1_a : 8'b0, 4'b0};
    wire [15:0] pp5 = {3'b0, stage1_b[5] ? stage1_a : 8'b0, 5'b0};
    wire [15:0] pp6 = {2'b0, stage1_b[6] ? stage1_a : 8'b0, 6'b0};
    wire [15:0] pp7 = {1'b0, stage1_b[7] ? stage1_a : 8'b0, 7'b0};

    // Calculate intermediate sums
    wire [15:0] sum_low = stage2_pp0 + stage2_pp1 + stage2_pp2 + stage2_pp3;
    wire [15:0] sum_high = stage2_pp4 + stage2_pp5 + stage2_pp6 + stage2_pp7;
    wire [15:0] final_sum = sum_low + sum_high;

    // Pipeline stage 1: Input registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
        end else begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
        end
    end

    // Pipeline stage 2: Partial product registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {stage2_pp0, stage2_pp1, stage2_pp2, stage2_pp3} <= {16'b0, 16'b0, 16'b0, 16'b0};
            {stage2_pp4, stage2_pp5, stage2_pp6, stage2_pp7} <= {16'b0, 16'b0, 16'b0, 16'b0};
            stage2_en <= 1'b0;
        end else begin
            stage2_pp0 <= pp0;
            stage2_pp1 <= pp1;
            stage2_pp2 <= pp2;
            stage2_pp3 <= pp3;
            stage2_pp4 <= pp4;
            stage2_pp5 <= pp5;
            stage2_pp6 <= pp6;
            stage2_pp7 <= pp7;
            stage2_en <= stage1_en;
        end
    end

    // Pipeline stage 3: Final result registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_result <= 16'b0;
            stage3_en <= 1'b0;
        end else begin
            stage3_result <= final_sum;
            stage3_en <= stage2_en;
        end
    end

    // Output assignments
    assign mul_en_out = stage3_en;
    assign mul_out = stage3_en ? stage3_result : 16'b0;

endmodule