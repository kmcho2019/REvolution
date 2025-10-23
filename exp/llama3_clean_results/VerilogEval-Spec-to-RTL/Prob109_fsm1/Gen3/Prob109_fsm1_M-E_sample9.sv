module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg state; // 1-bit signal to represent the state
reg next_state; // 1-bit signal to represent the next state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Asynchronously reset to state B
    end else begin
        state <= next_state;
    end
end

// Next state logic using a 2:1 multiplexer
always @(*) begin
    case(state)
        1'b0: next_state = in ? 1'b0 : 1'b1; // State A transitions
        1'b1: next_state = in ? 1'b1 : 1'b0; // State B transitions
    endcase
end

// Output logic
always @(*) begin
    case(state)
        1'b0: out = 1'b0; // Output for state A
        1'b1: out = 1'b1; // Output for state B
    endcase
end

endmodule