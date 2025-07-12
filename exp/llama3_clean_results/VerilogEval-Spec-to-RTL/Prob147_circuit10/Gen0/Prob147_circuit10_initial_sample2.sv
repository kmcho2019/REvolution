module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
reg state_next;

always @(posedge clk) begin
    state_reg <= state_next;
end

always @(*) begin
    state_next = state_reg ^ a;
    q = state_reg ^ b;
    state = state_reg;
end

endmodule