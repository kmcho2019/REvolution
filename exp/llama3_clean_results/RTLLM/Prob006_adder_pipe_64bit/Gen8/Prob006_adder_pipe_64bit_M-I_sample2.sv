module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] sum;
reg [63:0] prev_sum;
reg [64:0] final_sum;
reg o_en_reg;
reg i_en_reg;
reg i_en_reg2;

assign result = final_sum;
assign o_en = o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 64'd0;
        prev_sum <= 64'd0;
        final_sum <= 65'd0;
        i_en_reg <= 1'b0;
        i_en_reg2 <= 1'b0;
        o_en_reg <= 1'b0;
    end else begin
        i_en_reg <= i_en;
        i_en_reg2 <= i_en_reg;
        if (i_en) begin
            sum <= adda + addb;
        end
        if (i_en_reg) begin
            prev_sum <= sum;
        end
        if (i_en_reg2) begin
            final_sum <= {1'b0, prev_sum} + {64{1'b0}};
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

endmodule