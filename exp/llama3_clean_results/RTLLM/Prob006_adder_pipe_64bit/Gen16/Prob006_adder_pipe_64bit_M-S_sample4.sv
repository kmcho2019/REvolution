module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] sum_reg;
reg [63:0] carry_reg;
reg         o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= 64'd0;
        carry_reg <= 64'd0;
        o_en_reg <= 1'b0;
    end else begin
        sum_reg <= 64'd0;
        carry_reg <= 64'd0;
        for (int i = 0; i < 64; i++) begin
            if (i == 0) begin
                sum_reg[i] = adda[i] ^ addb[i];
                carry_reg[i] = adda[i] & addb[i];
            end else begin
                sum_reg[i] = adda[i] ^ addb[i] ^ carry_reg[i-1];
                carry_reg[i] = (adda[i] & addb[i]) | (adda[i] & carry_reg[i-1]) | (addb[i] & carry_reg[i-1]);
            end
        end
        o_en_reg <= i_en;
    end
end

assign result = {carry_reg[63], sum_reg};
assign o_en = o_en_reg;

endmodule