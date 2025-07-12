module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] reg_a;
reg [63:0] reg_b;
reg [64:0] reg_sum;
reg o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_a <= 64'd0;
        reg_b <= 64'd0;
        reg_sum <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        reg_a <= adda;
        reg_b <= addb;
    end else begin
        reg_a <= reg_a;
        reg_b <= reg_b;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_sum <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (reg_a != 64'd0 || reg_b != 64'd0) begin
        reg_sum <= {1'b0, reg_a} + {1'b0, reg_b};
        o_en_reg <= 1'b1;
    end else begin
        reg_sum <= reg_sum;
        o_en_reg <= o_en_reg;
    end
end

assign result = reg_sum;
assign o_en = o_en_reg;

endmodule