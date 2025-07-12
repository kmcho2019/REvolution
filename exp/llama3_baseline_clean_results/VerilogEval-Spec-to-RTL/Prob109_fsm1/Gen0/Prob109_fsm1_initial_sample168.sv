module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg state;  // Current state
reg next_state;  // Next state

// Combinational logic to determine the next state
always @(*) begin
    case(state)
        1'b0: next_state = (in == 1'b0) ? 1'b1 : 1'b0;
        1'b1: next_state = (in == 1'b0) ? 1'b0 : 1'b1;
        default: next_state = 1'b1; // Default to state B
    endcase
end

// Sequential logic to update the state at every clock cycle
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Asynchronous reset to state B
    end else begin
        state <= next_state; // Update state
    end
end

// Output logic
assign out = state;

endmodule