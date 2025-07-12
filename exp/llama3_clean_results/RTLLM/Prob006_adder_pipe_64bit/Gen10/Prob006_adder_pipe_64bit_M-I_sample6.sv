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

reg [DATA_WIDTH-1:0] sum;
reg [DATA_WIDTH:0] final_sum;
reg o_en_reg;
reg i_en_reg;
reg i_en_reg2;

assign result = final_sum;
assign o_en = o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= '0;
        final_sum <= '0;
        i_en_reg <= 1'b0;
        i_en_reg2 <= 1'b0;
        o_en_reg <= 1'b0;
    end else begin
        i_en_reg <= i_en;
        i_en_reg2 <= i_en_reg;
        if (i_en) begin
            sum <= adda + addb;
        end
        if (i_en_reg2) begin
            final_sum <= {1'b0, sum} + 1'b0; // Carry is 0 since it's added to sum
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

endmodule