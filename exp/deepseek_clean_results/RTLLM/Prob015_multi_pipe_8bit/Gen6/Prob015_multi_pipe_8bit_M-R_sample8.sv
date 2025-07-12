module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline stage 1: Input sampling
reg [7:0] stage1_a, stage1_b;
reg stage1_en;

// Pipeline stage 2: Partial product generation
reg [15:0] stage2_pp0, stage2_pp1, stage2_pp2, stage2_pp3;
reg [15:0] stage2_pp4, stage2_pp5, stage2_pp6, stage2_pp7;
reg stage2_en;

// Pipeline stage 3: First level addition
reg [15:0] stage3_sum0, stage3_sum1;
reg stage3_en;

// Pipeline stage 4: Final addition
reg stage4_en;

// Continuous assignments for partial products
wire [15:0] pp0 = {8'b0, stage1_a} & {16{stage1_b[0]}};
wire [15:0] pp1 = {7'b0, stage1_a, 1'b0} & {16{stage1_b[1]}};
wire [15:0] pp2 = {6'b0, stage1_a, 2'b0} & {16{stage1_b[2]}};
wire [15:0] pp3 = {5'b0, stage1_a, 3'b0} & {16{stage1_b[3]}};
wire [15:0] pp4 = {4'b0, stage1_a, 4'b0} & {16{stage1_b[4]}};
wire [15:0] pp5 = {3'b0, stage1_a, 5'b0} & {16{stage1_b[5]}};
wire [15:0] pp6 = {2'b0, stage1_a, 6'b0} & {16{stage1_b[6]}};
wire [15:0] pp7 = {1'b0, stage1_a, 7'b0} & {16{stage1_b[7]}};

// Pipeline stage 1: Input sampling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 8'b0;
        stage1_b <= 8'b0;
        stage1_en <= 1'b0;
    end else begin
        stage1_en <= mul_en_in;
        if (mul_en_in) begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
        end
    end
end

// Pipeline stage 2: Partial product generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_pp0 <= 16'b0;
        stage2_pp1 <= 16'b0;
        stage2_pp2 <= 16'b0;
        stage2_pp3 <= 16'b0;
        stage2_pp4 <= 16'b0;
        stage2_pp5 <= 16'b0;
        stage2_pp6 <= 16'b0;
        stage2_pp7 <= 16'b0;
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

// Pipeline stage 3: First level addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_sum0 <= 16'b0;
        stage3_sum1 <= 16'b0;
        stage3_en <= 1'b0;
    end else begin
        stage3_sum0 <= stage2_pp0 + stage2_pp1 + stage2_pp2 + stage2_pp3;
        stage3_sum1 <= stage2_pp4 + stage2_pp5 + stage2_pp6 + stage2_pp7;
        stage3_en <= stage2_en;
    end
end

// Pipeline stage 4: Final addition and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        mul_out <= stage3_sum0 + stage3_sum1;
        mul_en_out <= stage3_en;
    end
end

endmodule