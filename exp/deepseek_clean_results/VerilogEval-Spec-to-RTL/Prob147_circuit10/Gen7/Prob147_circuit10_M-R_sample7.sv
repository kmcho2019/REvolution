module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

wire state_input = a ^ b;
reg state_reg = 0;

always @(posedge clk) begin
    state_reg <= state_input;
end

assign q = state_reg ^ (a & b);
assign state = state_reg;

endmodule