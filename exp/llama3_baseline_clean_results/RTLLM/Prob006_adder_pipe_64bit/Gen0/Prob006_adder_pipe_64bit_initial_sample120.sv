module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg    [63:0]  adda_reg1;
reg    [63:0]  addb_reg1;
reg             i_en_reg1;
reg    [63:0]  adda_reg2;
reg    [63:0]  addb_reg2;
reg             i_en_reg2;
reg    [64:0]  result_reg;

wire   [63:0]  sum;
wire            carry;

assign sum = adda_reg2 + addb_reg2;
assign carry = (sum[63] + adda_reg2[63] + addb_reg2[63]) > 1 ? 1 : 0;
assign result = {carry, sum[63:1]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        i_en_reg1 <= 1'b0;
        adda_reg2 <= 64'd0;
        addb_reg2 <= 64'd0;
        i_en_reg2 <= 1'b0;
        result_reg <= 65'd0;
        o_en <= 1'b0;
    end else begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= i_en;
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= i_en_reg1;
        result_reg <= result;
        o_en <= i_en_reg2;
    end
end

assign result = result_reg;

endmodule