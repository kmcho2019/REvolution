module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline Stage 1: Lower 32-bit addition
reg [31:0] adda_lo_reg, addb_lo_reg;
reg stage1_en_reg;
wire [32:0] sum_lo = {1'b0, adda_lo_reg} + {1'b0, addb_lo_reg};
wire stage1_carry = sum_lo[32];

// Pipeline Stage 2: Upper 32-bit addition with carry
reg [31:0] adda_hi_reg, addb_hi_reg;
reg stage2_en_reg;
wire [32:0] sum_hi = {1'b0, adda_hi_reg} + {1'b0, addb_hi_reg} + stage1_carry;

// Combinational output formation
wire [64:0] result_next = {sum_hi[31:0], sum_lo[31:0]};

// Stage 1 Registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_lo_reg <= 32'b0;
        addb_lo_reg <= 32'b0;
        stage1_en_reg <= 1'b0;
    end else begin
        adda_lo_reg <= adda[31:0];
        addb_lo_reg <= addb[31:0];
        stage1_en_reg <= i_en;
    end
end

// Stage 2 Registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_hi_reg <= 32'b0;
        addb_hi_reg <= 32'b0;
        stage2_en_reg <= 1'b0;
    end else begin
        adda_hi_reg <= adda[63:32];
        addb_hi_reg <= addb[63:32];
        stage2_en_reg <= stage1_en_reg;
    end
end

// Output Registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= result_next;
        o_en <= stage2_en_reg;
    end
end

endmodule