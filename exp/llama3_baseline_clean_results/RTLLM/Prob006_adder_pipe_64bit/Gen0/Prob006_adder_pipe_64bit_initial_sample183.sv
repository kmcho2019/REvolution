module adder_pipe_64bit (
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
reg [0:0] reg_o_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_result <= 64'd0;
        reg_o_en <= 1'b0;
    end
    else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        reg_o_en <= 1'b1;
    end
    else begin
        reg_o_en <= 1'b0;
    end
end

always @(*) begin
    result = reg_adda + reg_addb;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en <= 1'b0;
    end
    else begin
        o_en <= reg_o_en;
    end
end

endmodule