module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Pipeline stage 2 registers
    reg [7:0] stage2_a, stage2_b;
    reg stage2_en;
    reg [15:0] stage2_sum_low, stage2_sum_high;
    
    // Pipeline stage 3 registers
    reg [15:0] stage3_result;
    reg stage3_en;

    // Continuous assignments for partial products
    wire [15:0] pp0 = {8'b0, stage1_a} & {16{stage1_b[0]}};
    wire [15:0] pp1 = {7'b0, stage1_a, 1'b0} & {16{stage1_b[1]}};
    wire [15:0] pp2 = {6'b0, stage1_a, 2'b0} & {16{stage1_b[2]}};
    wire [15:0] pp3 = {5'b0, stage1_a, 3'b0} & {16{stage1_b[3]}};
    wire [15:0] pp4 = {4'b0, stage1_a, 4'b0} & {16{stage1_b[4]}};
    wire [15:0] pp5 = {3'b0, stage1_a, 5'b0} & {16{stage1_b[5]}};
    wire [15:0] pp6 = {2'b0, stage1_a, 6'b0} & {16{stage1_b[6]}};
    wire [15:0] pp7 = {1'b0, stage1_a, 7'b0} & {16{stage1_b[7]}};

    // Continuous assignments for intermediate sums
    assign stage2_sum_low = pp0 + pp1 + pp2 + pp3;
    assign stage2_sum_high = pp4 + pp5 + pp6 + pp7;

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

    // Pipeline stage 2: Partial sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_a <= 8'b0;
            stage2_b <= 8'b0;
            stage2_en <= 1'b0;
            stage2_sum_low <= 16'b0;
            stage2_sum_high <= 16'b0;
        end else begin
            stage2_a <= stage1_a;
            stage2_b <= stage1_b;
            stage2_en <= stage1_en;
            stage2_sum_low <= pp0 + pp1 + pp2 + pp3;
            stage2_sum_high <= pp4 + pp5 + pp6 + pp7;
        end
    end

    // Pipeline stage 3: Final sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_result <= 16'b0;
            stage3_en <= 1'b0;
        end else begin
            stage3_result <= stage2_sum_low + stage2_sum_high;
            stage3_en <= stage2_en;
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 16'b0;
            mul_en_out <= 1'b0;
        end else begin
            mul_out <= stage3_en ? stage3_result : 16'b0;
            mul_en_out <= stage3_en;
        end
    end

endmodule