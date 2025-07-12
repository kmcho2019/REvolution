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
reg [64:0] reg_sum;
reg [64:0] reg_result;
reg o_en_reg;
reg i_en_reg;

assign result = reg_result;
assign o_en = o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_sum <= 65'd0;
        reg_result <= 65'd0;
        o_en_reg <= 1'b0;
        i_en_reg <= 1'b0;
    end else begin
        if (i_en) begin
            reg_adda <= adda;
            reg_addb <= addb;
            i_en_reg <= 1'b1;
        end
        if (i_en_reg) begin
            reg_sum <= reg_adda + reg_addb;
            i_en_reg <= 1'b0;
        end
        if (reg_sum != 65'd0) begin
            reg_result <= reg_sum;
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

endmodule