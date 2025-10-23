module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output reg o_en
);

// Pipeline stage 1 signals
wire [31:0] stage1_sum_lo = adda[31:0] + addb[31:0];
wire stage1_carry = stage1_sum_lo[32];
wire [31:0] stage1_sum = stage1_sum_lo[31:0];

// Pipeline stage 2 signals
reg [31:0] stage2_hi_a, stage2_hi_b;
reg [31:0] stage2_sum_lo;
reg stage2_carry;
wire [32:0] stage2_sum_hi = stage2_hi_a + stage2_hi_b + stage2_carry;

// Pipeline control signals
reg stage1_valid, stage2_valid;

// Output assignment
assign result = {stage2_sum_hi, stage2_sum_lo};

// Pipeline stage 1 registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_hi_a <= 32'b0;
        stage2_hi_b <= 32'b0;
        stage2_sum_lo <= 32'b0;
        stage2_carry <= 1'b0;
        stage1_valid <= 1'b0;
    end else begin
        stage2_hi_a <= adda[63:32];
        stage2_hi_b <= addb[63:32];
        stage2_sum_lo <= stage1_sum;
        stage2_carry <= stage1_carry;
        stage1_valid <= i_en;
    end
end

// Pipeline stage 2 registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en <= 1'b0;
        stage2_valid <= 1'b0;
    end else begin
        o_en <= stage2_valid;
        stage2_valid <= stage1_valid;
    end
end

endmodule