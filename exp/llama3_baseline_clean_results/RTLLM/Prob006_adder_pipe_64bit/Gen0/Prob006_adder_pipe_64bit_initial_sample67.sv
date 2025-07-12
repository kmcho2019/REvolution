module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg [63:0] reg_sum;
reg i_en_reg;
reg [63:0] carry_reg;
reg o_en_reg;

assign result = {1'b0, reg_sum} + {64'b0, carry_reg};
assign o_en = o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_sum <= 64'd0;
        carry_reg <= 64'd0;
        i_en_reg <= 1'b0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        i_en_reg <= 1'b1;
    end else if (i_en_reg) begin
        {carry_reg, reg_sum} <= reg_adda + reg_addb + carry_reg;
        i_en_reg <= 1'b0;
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

endmodule