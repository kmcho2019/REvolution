module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 0;

always @(posedge clk) begin
    q_reg <= (shift_ena) ? {data, q_reg[3:1]} : (count_ena) ? (q_reg == 0) ? 0 : q_reg - 1 : q_reg;
end

assign q = q_reg;

endmodule