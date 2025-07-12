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
reg [64:0] reg_result;
reg o_en_reg;
reg [1:0] pipeline_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_sum <= 64'd0;
        reg_carry <= 64'd0;
        reg_result <= 65'd0;
        o_en_reg <= 1'b0;
        pipeline_reg <= 2'd0;
    end else begin
        if (i_en) begin
            reg_adda <= adda;
            reg_addb <= addb;
            pipeline_reg <= pipeline_reg + 1;
        end
        if (pipeline_reg == 2'd1) begin
            reg_sum <= reg_adda + reg_addb;
            reg_carry <= (reg_adda[63] + reg_addb[63] + 1'd1) >> 1;
        end
        if (pipeline_reg == 2'd2) begin
            reg_result <= {1'b0, reg_sum} + {reg_carry, 64'd0};
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
        if (pipeline_reg == 2'd3) begin
            pipeline_reg <= 2'd0;
        end
    end
end

assign result = reg_result;
assign o_en = o_en_reg;

endmodule