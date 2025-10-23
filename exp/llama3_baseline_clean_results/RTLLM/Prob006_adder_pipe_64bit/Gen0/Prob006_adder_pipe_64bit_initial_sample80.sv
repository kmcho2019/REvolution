module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg i_en_reg;
reg [63:0] sum_reg;
reg [63:0] carry_reg;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'b0;
        sum_reg <= 64'd0;
        carry_reg <= 64'd0;
        o_en_reg <= 1'b0;
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= i_en;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
        i_en_reg <= i_en_reg;
    end

    if (i_en_reg) begin
        {carry_reg, sum_reg} <= adda_reg + addb_reg + carry_reg;
    end else begin
        carry_reg <= 64'd0;
        sum_reg <= 64'd0;
    end

    if (i_en_reg) begin
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= o_en_reg;
    end

    result <= {carry_reg[63], sum_reg};
    o_en <= o_en_reg;
end

endmodule