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
reg [63:0] stage_a, stage_b;
reg [31:0] sum_low, sum_high;
reg carry_low;
reg en_reg;

// Intermediate signals
wire [32:0] sum_low_w, sum_high_w;

// Stage 1: Input registration and first 32-bit addition
assign sum_low_w = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_a <= 64'b0;
        stage_b <= 64'b0;
        sum_low <= 32'b0;
        carry_low <= 1'b0;
        en_reg <= 1'b0;
    end else begin
        stage_a <= adda;
        stage_b <= addb;
        sum_low <= sum_low_w[31:0];
        carry_low <= sum_low_w[32];
        en_reg <= i_en;
    end
end

// Stage 2: Second 32-bit addition with carry and result assembly
assign sum_high_w = {1'b0, stage_a[63:32]} + {1'b0, stage_b[63:32]} + carry_low;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_high <= 32'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        sum_high <= sum_high_w[31:0];
        result <= {sum_high_w[32], sum_high, sum_low};
        o_en <= en_reg;
    end
end

endmodule