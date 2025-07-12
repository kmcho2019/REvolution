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
reg [63:0] reg_carry;
reg i_en_reg;
reg i_en_reg2;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_sum <= 64'd0;
        reg_carry <= 64'd0;
        i_en_reg <= 1'b0;
        i_en_reg2 <= 1'b0;
        o_en_reg <= 1'b0;
    end else begin
        i_en_reg <= i_en;
        i_en_reg2 <= i_en_reg;
        o_en_reg <= i_en_reg2;
        
        if (i_en) begin
            reg_adda <= adda;
            reg_addb <= addb;
        end
        
        {reg_carry, reg_sum} <= reg_adda + reg_addb + reg_carry;
    end
end

assign result = {reg_carry, reg_sum};
assign o_en = o_en_reg;

endmodule