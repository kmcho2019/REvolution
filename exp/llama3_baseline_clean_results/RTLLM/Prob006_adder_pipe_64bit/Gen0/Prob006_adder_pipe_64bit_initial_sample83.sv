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
reg i_en_reg;
reg i_en_reg2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_sum <= 65'd0;
        i_en_reg <= 1'b0;
        i_en_reg2 <= 1'b0;
    end else begin
        reg_adda <= adda;
        reg_addb <= addb;
        i_en_reg <= i_en;
        i_en_reg2 <= i_en_reg;
    end
end

wire [63:0] sum;
assign sum = reg_adda + reg_addb;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_sum <= 65'd0;
    end else begin
        reg_sum <= {1'b0, sum} + 65'd1;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en_reg2) begin
        result <= reg_sum;
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

endmodule