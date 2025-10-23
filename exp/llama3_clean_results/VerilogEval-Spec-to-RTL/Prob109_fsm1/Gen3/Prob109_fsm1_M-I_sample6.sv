module TopModule(
    input           clk,
    input           areset,
    input           in,
    output          out
);

reg state; // 1 represents state B, 0 represents state A
reg next_state;

// Simplified combinational logic to determine next state
always @(*)
begin
    next_state = state;
    case(state)
        1'b1: // State B
            if (~in) next_state = 1'b0;
        1'b0: // State A
            if (~in) next_state = 1'b1;
    endcase
end

// Sequential logic to update current state
always @(posedge clk or posedge areset)
begin
    if (areset) state <= 1'b1; // Reset to state B
    else state <= next_state;
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule