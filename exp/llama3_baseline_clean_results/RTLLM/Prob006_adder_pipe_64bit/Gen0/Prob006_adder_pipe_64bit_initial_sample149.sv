module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] stage1_sum;
reg [63:0] stage2_sum;
reg [0:0] stage1_cout;
reg [0:0] stage2_cout;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_sum <= 64'd0;
        stage2_sum <= 64'd0;
        stage1_cout <= 1'b0;
        stage2_cout <= 1'b0;
        o_en <= 1'b0;
    end
    else if (i_en) begin
        stage1_sum <= adda + addb;
        stage1_cout <= (adda[63] + addb[63] + 1'b0) > 63 ? 1'b1 : 1'b0;
        o_en <= 1'b0;
    end
    else begin
        stage2_sum <= stage1_sum;
        stage2_cout <= stage1_cout;
        o_en <= i_en;
    end
end

always @(*) begin
    if (~rst_n) begin
        result <= 65'd0;
    end
    else if (i_en) begin
        result <= {1'b0, adda} + {1'b0, addb};
    end
    else begin
        result <= {stage2_cout, stage2_sum};
    end
end

endmodule