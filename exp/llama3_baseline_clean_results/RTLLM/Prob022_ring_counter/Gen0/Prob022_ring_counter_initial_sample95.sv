module ring_counter(
    input clk,  // Clock signal
    input reset,  // Reset signal
    output [7:0] out  // 8-bit output
);

reg [7:0] state;  // Register to hold the current state

// Initialize the state to the starting state when reset is high
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 8'b0000_0001;  // Reset to the initial state
    end else begin
        // Update the state to the next position in the sequence
        state <= {state[6:0], state[7]};  // Shift left and wrap around
    end
end

// Assign the current state to the output
assign out = state;

endmodule