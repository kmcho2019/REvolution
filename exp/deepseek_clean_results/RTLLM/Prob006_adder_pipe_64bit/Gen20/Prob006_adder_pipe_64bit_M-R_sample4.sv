module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output reg o_en
);

// Parameters
parameter DATA_WIDTH = 64;
parameter STG_WIDTH = 32;

// Pipeline stage 1 registers
reg [DATA_WIDTH-1:0] a_reg, b_reg;
reg [STG_WIDTH-1:0] sum_lo_reg;
reg carry_lo_reg;
reg en_stage1;

// Pipeline stage 2 registers
reg [STG_WIDTH-1:0] sum_hi_reg;
reg carry_hi_reg;
reg en_stage2;

// Combinational additions
wire [STG_WIDTH:0] sum_lo = {1'b0, adda[STG_WIDTH-1:0]} + {1'b0, addb[STG_WIDTH-1:0]};
wire [STG_WIDTH:0] sum_hi = {1'b0, a_reg[63:32]} + {1'b0, b_reg[63:32]} + carry_lo_reg;

// Final result assignment
assign result = {carry_hi_reg, sum_hi_reg, sum_lo_reg};

// Pipeline stage 1: Register inputs and compute lower sum
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        sum_lo_reg <= 32'b0;
        carry_lo_reg <= 1'b0;
        en_stage1 <= 1'b0;
    end else begin
        a_reg <= adda;
        b_reg <= addb;
        sum_lo_reg <= sum_lo[31:0];
        carry_lo_reg <= sum_lo[32];
        en_stage1 <= i_en;
    end
end

// Pipeline stage 2: Compute upper sum with carry
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_hi_reg <= 32'b0;
        carry_hi_reg <= 1'b0;
        en_stage2 <= 1'b0;
        o_en <= 1'b0;
    end else begin
        sum_hi_reg <= sum_hi[31:0];
        carry_hi_reg <= sum_hi[32];
        en_stage2 <= en_stage1;
        o_en <= en_stage2;
    end
end

endmodule