module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

// State simply follows input 'a'
always @(posedge clk) begin
    state_reg <= a;
end

// Output is XOR of state and b
assign q = state_reg ^ b;
assign state = state_reg;

endmodule