module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg state; // 1 represents state B, 0 represents state A

// Combinational logic to determine next state
always @(*)
begin
    if (state == 1'b1) // State B
        next_state = in ? 1'b1 : 1'b0; // Stay in B on 1, go to A on 0
    else // State A
        next_state = in ? 1'b0 : 1'b1; // Stay in A on 1, go to B on 0
end

reg next_state;

// Sequential logic to update current state
always @(posedge clk or posedge areset)
begin
    if (areset) state <= 1'b1; // Reset to state B
    else state <= next_state;
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule