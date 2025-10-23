module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg [64:0] reg_result;
reg        reg_o_en;

assign result = reg_result;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_result <= 65'd0;
        reg_o_en <= 1'b0;
    end else begin
        if (i_en) begin
            reg_adda <= adda;
            reg_addb <= addb;
            reg_o_en <= 1'b1;
        end else begin
            reg_o_en <= 1'b0;
        end
    end
end

always @ (posedge clk) begin
    if (i_en) begin
        reg_result <= {1'b0, reg_adda} + {1'b0, reg_addb};
    end
end

assign o_en = reg_o_en;

endmodule