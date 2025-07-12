module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'b0;

always @(posedge clk) begin
    if (shift_ena) begin
        q_reg <= {q_reg[2:0], data};
    end else if (count_ena) begin
        q_reg <= q_reg - 1'b1;
    end
end

assign q = q_reg;

endmodule