module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [64:0] sum_reg;
reg i_en_reg;
reg i_en_reg2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        sum_reg <= 65'd0;
        i_en_reg <= 1'b0;
        i_en_reg2 <= 1'b0;
        o_en <= 1'b0;
    end else begin
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
            i_en_reg <= 1'b1;
        end

        if (i_en_reg) begin
            i_en_reg2 <= 1'b1;
        end

        if (i_en_reg2) begin
            sum_reg <= adda_reg + addb_reg;
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

assign result = sum_reg;

endmodule