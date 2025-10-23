module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64
)(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH:0]  result,
    output          o_en
);

reg [DATA_WIDTH:0] result_reg;
reg o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= {DATA_WIDTH+1{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        result_reg <= {1'b0, adda} + {1'b0, addb};
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule