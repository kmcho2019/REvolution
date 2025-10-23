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
reg [64:0] next_sum;
reg [0:0] carry_in;
reg o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 65'd0;
        carry_in <= 1'b0;
        o_en_reg <= 1'b0;
    end else begin
        if (i_en) begin
            next_sum <= adda + addb;
            carry_in <= next_sum[64];
            sum <= next_sum;
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

assign result = {carry_in, sum[63:0]};
assign o_en = o_en_reg;

endmodule