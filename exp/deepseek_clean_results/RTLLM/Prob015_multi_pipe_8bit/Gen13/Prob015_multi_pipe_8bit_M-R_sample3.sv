module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage 1 registers
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;

    // Pipeline stage 2 registers
    reg [15:0] stage2_sum_low, stage2_sum_high;
    reg stage2_en;

    // Pipeline stage 3 registers
    reg [15:0] stage3_result;
    reg stage3_en;

    // Continuous assignments for partial products
    wire [15:0] pp [7:0];
    assign pp[0] = {8'b0, stage1_b[0] ? stage1_a : 8'b0};
    assign pp[1] = {7'b0, stage1_b[1] ? stage1_a : 8'b0, 1'b0};
    assign pp[2] = {6'b0, stage1_b[2] ? stage1_a : 8'b0, 2'b0};
    assign pp[3] = {5'b0, stage1_b[3] ? stage1_a : 8'b0, 3'b0};
    assign pp[4] = {4'b0, stage1_b[4] ? stage1_a : 8'b0, 4'b0};
    assign pp[5] = {3'b0, stage1_b[5] ? stage1_a : 8'b0, 5'b0};
    assign pp[6] = {2'b0, stage1_b[6] ? stage1_a : 8'b0, 6'b0};
    assign pp[7] = {1'b0, stage1_b[7] ? stage1_a : 8'b0, 7'b0};

    // Continuous assignments for intermediate sums
    wire [15:0] sum_low = pp[0] + pp[1] + pp[2] + pp[3];
    wire [15:0] sum_high = pp[4] + pp[5] + pp[6] + pp[7];
    wire [15:0] final_sum = stage2_sum_low + stage2_sum_high;

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

    // Pipeline stage 2: Partial sum calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum_low <= 16'b0;
            stage2_sum_high <= 16'b0;
            stage2_en <= 1'b0;
        end else begin
            stage2_sum_low <= sum_low;
            stage2_sum_high <= sum_high;
            stage2_en <= stage1_en;
        end
    end

    // Pipeline stage 3: Final result
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