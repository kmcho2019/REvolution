module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
wire next_state;

// Next state logic: when b=1, state becomes a, else keep current state
assign next_state = b ? a : state_reg;

// Output logic: q is simply b XOR state
assign q = b ^ state_reg;

always @(posedge clk) begin
    state_reg <= next_state;
end

assign state = state_reg;

endmodule