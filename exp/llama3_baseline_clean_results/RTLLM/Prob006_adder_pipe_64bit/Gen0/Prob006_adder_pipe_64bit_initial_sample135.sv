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

assign result = {reg_carry[63], reg_sum};
assign o_en = o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_sum <= 64'd0;
        reg_carry <= 64'd0;
        i_en_reg <= 1'b0;
        i_en_reg2 <= 1'b0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        i_en_reg <= 1'b1;
        o_en_reg <= 1'b0;
    end else begin
        i_en_reg <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_reg2 <= 1'b0;
        reg_sum <= 64'd0;
        reg_carry <= 64'd0;
    end else if (i_en_reg) begin
        i_en_reg2 <= 1'b1;
    end else begin
        i_en_reg2 <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en_reg2) begin
        reg_sum <= reg_adda + reg_addb;
        reg_carry <= (reg_adda[63] + reg_addb[63] + (reg_adda[62:0] + reg_addb[62:0])[63]);
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

endmodule