module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'b0;

wire [3:0] next_state;

assign next_state = (shift_ena) ? {data, q_reg[3:1]} : 
                     (count_ena) ? (q_reg == 4'b0) ? 4'b0 : q_reg - 1 : 
                     q_reg;

always @(posedge clk) begin
    q_reg <= next_state;
end

assign q = q_reg;

endmodule