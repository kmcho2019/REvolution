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
reg reg_i_en;
reg [64:0] sum;
reg [63:0] reg_sum;
reg reg_o_en;

// Input register stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_i_en <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        reg_i_en <= i_en;
    end
end

// Ripple carry adder stage
always @(*) begin
    sum = reg_adda + reg_addb;
end

// Output register stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_sum <= 64'd0;
        reg_o_en <= 1'b0;
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (reg_i_en) begin
        reg_sum <= sum[63:0];
        reg_o_en <= 1'b1;
        result <= {sum[63], sum[63:0]};
        o_en <= reg_o_en;
    end else begin
        reg_o_en <= 1'b0;
        o_en <= reg_o_en;
    end
end

endmodule