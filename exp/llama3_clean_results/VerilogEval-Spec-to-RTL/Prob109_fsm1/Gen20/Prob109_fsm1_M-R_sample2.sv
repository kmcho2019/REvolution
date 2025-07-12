module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg state; // 1 represents state B, 0 represents state A
reg next_state;

// Combinational logic for next state
assign next_state = (~in && state) || (state && in);

// Sequential logic to update current state
always @(posedge clk or posedge areset)
begin
    if (areset) state <= 1'b1; // Reset to state B
    else state <= next_state; // Update state
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule