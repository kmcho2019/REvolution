module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] stage1_a, stage1_b;
reg [31:0] sum_low;
reg carry_low;
reg [31:0] sum_high;
reg en1, en2;

// Stage 1: Input registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
        en1 <= 1'b0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        en1 <= i_en;
    end
end

// Stage 2: Lower 32-bit addition
wire [32:0] sum_low_w = stage1_a[31:0] + stage1_b[31:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_low <= 32'b0;
        carry_low <= 1'b0;
        en2 <= 1'b0;
    end else begin
        sum_low <= sum_low_w[31:0];
        carry_low <= sum_low_w[32];
        en2 <= en1;
    end
end

// Stage 3: Upper 32-bit addition with carry
wire [32:0] sum_high_w = stage1_a[63:32] + stage1_b[63:32] + carry_low;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_high <= 32'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        sum_high <= sum_high_w[31:0];
        result <= {sum_high_w[32], sum_high, sum_low};
        o_en <= en2;
    end
end

endmodule