module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit signal representing the current state
reg next_state; // 1-bit signal representing the next state

// Next state logic
always @(*) begin
    case (state)
        1'b0: next_state = (in)? 1'b0 : 1'b1;
        1'b1: next_state = (in)? 1'b1 : 1'b0;
        default: next_state = 1'b1; // Default to state B
    endcase
end

// Current state update
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

// Out is directly derived from the state in this implementation
assign out = state;

endmodule