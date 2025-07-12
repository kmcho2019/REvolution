module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define internal signals for pipeline stages
reg [63:0] stage1_a, stage1_b;
reg [63:0] stage2_sum;
reg [63:0] stage2_carry;
reg [64:0] stage3_sum;
reg o_en_pipe;

// Pipeline stage 1: Register input operands and enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        o_en_pipe <= 1'b0;
    end else if (i_en) begin
        stage1_a <= adda;
        stage1_b <= addb;
        o_en_pipe <= 1'b1;
    end else begin
        stage1_a <= stage1_a;
        stage1_b <= stage1_b;
        o_en_pipe <= o_en_pipe;
    end
end

// Pipeline stage 2: Calculate sum and carry
wire [63:0] sum;
wire carry;
assign sum = stage1_a + stage1_b;
assign carry = (sum[63] + stage1_a[63] + stage1_b[63]) ? 1'b1 : 1'b0;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_sum <= 64'd0;
        stage2_carry <= 1'b0;
    end else begin
        stage2_sum <= sum;
        stage2_carry <= carry;
    end
end

// Pipeline stage 3: Generate final result and enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage3_sum <= 65'd0;
        o_en <= 1'b0;
    end else if (o_en_pipe) begin
        stage3_sum <= {1'b0, stage2_sum} + {stage2_carry, 64'd0};
        o_en <= o_en_pipe;
    end else begin
        stage3_sum <= stage3_sum;
        o_en <= o_en;
    end
end

// Assign output result
assign result = stage3_sum;

endmodule