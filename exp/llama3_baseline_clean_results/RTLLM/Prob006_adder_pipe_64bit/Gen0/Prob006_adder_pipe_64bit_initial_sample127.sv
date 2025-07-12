module adder_pipe_64bit (
    clk,
    rst_n,
    i_en,
    adda,
    addb,
    result,
    o_en
);

input           clk;
input           rst_n;
input           i_en;
input  [63:0]   adda;
input  [63:0]   addb;
output [64:0]   result;
output          o_en;

reg    [63:0]   reg_adda;
reg    [63:0]   reg_addb;
reg             reg_i_en;
reg    [64:0]   reg_result;
reg             reg_o_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda   <= 64'd0;
        reg_addb   <= 64'd0;
        reg_i_en   <= 1'b0;
        reg_result <= 65'd0;
        reg_o_en   <= 1'b0;
    end else begin
        reg_adda   <= adda;
        reg_addb   <= addb;
        reg_i_en   <= i_en;
        reg_o_en   <= reg_i_en;
    end
end

wire [63:0]   stage1_sum;
wire [63:0]   stage1_carry;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_sum   <= 64'd0;
        stage1_carry <= 64'd0;
    end else if (reg_i_en) begin
        {stage1_carry, stage1_sum} <= reg_adda + reg_addb;
    end else begin
        stage1_sum   <= 64'd0;
        stage1_carry <= 64'd0;
    end
end

assign result = {1'b0, stage1_sum} + {65'd0, stage1_carry};
assign o_en   = reg_o_en && reg_i_en;

endmodule