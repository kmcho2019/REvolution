module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // Current state
reg next_state; // Next state based on current state and input

// Combinational logic for next state
always @(*) begin
    case (state)
        1'b0: next_state = in ? 1'b0 : 1'b1;
        1'b1: next_state = in ? 1'b1 : 1'b0;
    endcase
end

// State update on clock edge or asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        state <= next_state; // Update state on clock edge
    end
end

// Output is directly derived from the state
assign out = state;

endmodule