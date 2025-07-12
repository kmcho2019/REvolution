module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg state; // 1 represents state B, 0 represents state A
reg next_state;

// Combinational logic to determine next state
always @(*)
begin
    case(state)
        1: // State B
            next_state = in ? 1 : 0; // Stay in B on 1, go to A on 0
        0: // State A
            next_state = in ? 0 : 1; // Stay in A on 1, go to B on 0
        default: next_state = 1; // Default to state B
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge areset)
begin
    if (areset) state <= 1; // Reset to state B
    else state <= next_state;
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule