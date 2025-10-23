module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg state; // 1-bit signal to represent the state
reg next_state; // 1-bit signal for the next state

// Combinational logic for next state
always @(*) begin
    case(state)
        1'b0: next_state = in ? 1'b0 : 1'b1; // State A transitions
        1'b1: next_state = in ? 1'b1 : 1'b0; // State B transitions
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Asynchronously reset to state B
    end else begin
        state <= next_state; // Update state on clock edge
    end
end

// Directly assign output based on the state
assign out = state;

endmodule