module ring_counter(
    input clk,  // Clock signal
    input reset,  // Reset signal
    output [7:0] out  // 8-bit output representing the current state
);

reg [7:0] state;  // Register to hold the current state

// Initialize the state to 1 when the reset signal is high
always @(posedge reset) begin
    state <= 8'b0000_0001;  // Initialize to the starting state
end

// Update the state on each rising edge of the clock signal
always @(posedge clk) begin
    if (~reset) begin  // Check if reset is not high
        // Shift the current state one position to the right (with wraparound)
        state <= {state[6:0], state[7]};  
    end else begin
        // If reset is high, maintain the initial state
        state <= 8'b0000_0001;  
    end
end

// Continuously assign the current state to the output
assign out = state;

endmodule