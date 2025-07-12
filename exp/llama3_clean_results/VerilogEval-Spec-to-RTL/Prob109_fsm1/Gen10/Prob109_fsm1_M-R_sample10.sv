module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out // Declare out as a reg for assignment
);

reg state; // 1-bit signal representing the counter value

// Combinational logic to determine the next state
always @(*) begin
    if (areset) begin // Asynchronous reset
        state = 1'b1; // Reset to state B
    end else if (~in) begin // Transition condition
        state = ~state; // Toggle state
    end else begin
        state = state; // Stay in the same state
    end
end

// Update state on clock edge
always @(posedge clk) begin
    if (~areset) begin // Ensure reset doesn't affect clocked logic
        out = state; // Update output with current state
    end
end

endmodule