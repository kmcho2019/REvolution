module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State is just previous cycle's a value
always @(posedge clk) begin
    state_reg <= a;
end

// Output logic
assign q = a ? (state_reg ^ b) : b;
assign state = state_reg;

endmodule