module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg [63:0] reg_result;
reg i_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_result <= 64'd0;
        i_en_reg <= 1'b0;
        o_en <= 1'b0;
        result <= 65'd0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        i_en_reg <= 1'b1;
    end else begin
        i_en_reg <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_result <= 64'd0;
        o_en <= 1'b0;
        result <= 65'd0;
    end else if (i_en_reg) begin
        reg_result <= adda + addb;
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'd0;
    end else if (o_en) begin
        result <= {1'b0, reg_result} + {65{1'b0}};
    end
end

endmodule