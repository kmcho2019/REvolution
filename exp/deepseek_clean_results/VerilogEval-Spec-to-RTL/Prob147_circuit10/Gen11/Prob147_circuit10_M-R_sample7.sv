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

assign q = (state_reg & (a ^ b)) | (~state_reg & (a | b));
assign state = state_reg;

endmodule