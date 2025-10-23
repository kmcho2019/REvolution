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
reg [63:0] reg_result;
reg [63:0] reg_carry;
reg o_en_reg;
reg i_en_reg;
reg i_en_reg2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i_en_reg <= 0;
        i_en_reg2 <= 0;
        o_en_reg <= 0;
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_result <= 64'd0;
        reg_carry <= 64'd0;
    end else begin
        if (i_en) begin
            reg_adda <= adda;
            reg_addb <= addb;
            i_en_reg <= 1;
        end
        if (i_en_reg) begin
            i_en_reg2 <= 1;
        end
        if (i_en_reg2) begin
            o_en_reg <= 1;
        end
    end
end

always @(posedge clk) begin
    if (i_en_reg) begin
        {reg_carry, reg_result} = reg_adda + reg_addb;
    end
end

assign result = {reg_carry[0], reg_result};
assign o_en = o_en_reg;

endmodule