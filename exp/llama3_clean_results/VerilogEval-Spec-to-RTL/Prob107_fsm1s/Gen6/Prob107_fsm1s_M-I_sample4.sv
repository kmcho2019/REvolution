module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state; // 1-bit variable to hold the state (0 or 1)

// Initialize the state to 1 (state B) to ensure a defined starting point
initial state = 1'b1;

// Directly assign the output based on the current state
assign out = (state == 1'b1)? 1'b1 : 1'b0;

// Sequential logic for state transitions
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        // Using if-else statements for potential optimization in certain synthesis tools
        if(state == 1'b0) begin // Currently in state A
            state <= (in == 1'b0)? 1'b1 : 1'b0; // Transition based on input
        end else begin // Currently in state B
            state <= (in == 1'b0)? 1'b0 : 1'b1; // Transition based on input
        end
    end
end

endmodule