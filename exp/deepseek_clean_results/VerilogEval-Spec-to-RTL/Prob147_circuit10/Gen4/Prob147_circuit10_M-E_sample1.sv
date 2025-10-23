module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;

// Next state logic: toggle when both a and b are high
wire toggle_condition = a & b;
wire next_state = toggle_condition ? ~state_reg : state_reg;

// Output logic: q is b XOR state
assign q = b ^ state_reg;

always @(posedge clk) begin
    state_reg <= next_state;
end

assign state = state_reg;

endmodule