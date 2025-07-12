module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [64:0] sum;
reg [64:0] result_reg;
reg o_en_reg;

assign result = result_reg;
assign o_en = o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 65'd0;
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        if (i_en) begin
            sum <= {1'b0, adda} + {1'b0, addb};
            result_reg <= sum;
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

endmodule