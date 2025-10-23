module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

always @(posedge clk) begin
    state_reg <= a;
end

assign q = state_reg ^ b;
assign state = state_reg;

endmodule