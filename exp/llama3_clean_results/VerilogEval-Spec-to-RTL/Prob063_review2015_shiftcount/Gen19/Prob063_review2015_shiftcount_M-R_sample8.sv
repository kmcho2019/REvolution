module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
wire [3:0] q_next;

assign q_next = (shift_ena) ? {q_reg[2:0], data} : (count_ena) ? (q_reg == 4'b0) ? 4'b1111 : q_reg - 1 : q_reg;

always @(posedge clk) begin
    q_reg <= q_next;
end

assign q = q_reg;

endmodule