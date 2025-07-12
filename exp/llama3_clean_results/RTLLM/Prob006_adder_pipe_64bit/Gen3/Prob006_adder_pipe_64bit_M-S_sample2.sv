module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [64:0] result_reg;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 0;
        addb_reg <= 0;
        result_reg <= 0;
        o_en_reg <= 0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        result_reg <= adda + addb;
        o_en_reg <= 1;
    end else begin
        o_en_reg <= 0;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule