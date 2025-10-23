module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit signal representing the current state

// Current state update
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset
        state <= 1'b1; // Reset to state B
    end else if (state == 1'b0) begin // State A
        state <= (in)? 1'b0 : 1'b1; // Transition from A to A if in=1, else to B
    end else if (state == 1'b1) begin // State B
        state <= (in)? 1'b1 : 1'b0; // Transition from B to B if in=1, else to A
    end else begin
        state <= 1'b1; // Default to state B
    end
end

// Out is directly derived from the state in this implementation
assign out = state;

endmodule