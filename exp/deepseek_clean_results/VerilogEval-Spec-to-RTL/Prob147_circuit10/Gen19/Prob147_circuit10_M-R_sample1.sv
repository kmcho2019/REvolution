module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

wire next_state = (a & b) ? 1'b1 : (~a & ~b) ? 1'b0 : state;
reg state_reg = 0;

always @(posedge clk) begin
    state_reg <= next_state;
end

assign q = a ^ b ^ state_reg;
assign state = state_reg;

endmodule