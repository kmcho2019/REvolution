module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

reg state; // current state (0 for B, 1 for A)
reg next_state; // next state

// Combinational logic to determine next state
always @(*) begin
    case(state)
        0: next_state = (in == 1) ? 0 : 1; // state B
        1: next_state = (in == 1) ? 1 : 0; // state A
        default: next_state = 0;
    endcase
end

// D flip-flop with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to state B
    end else begin
        state <= next_state;
    end
end

// Output logic
assign out = state;

endmodule