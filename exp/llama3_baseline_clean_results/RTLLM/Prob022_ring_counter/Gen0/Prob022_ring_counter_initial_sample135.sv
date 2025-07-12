module ring_counter(
    input clk,    // Clock signal
    input reset,  // Reset signal
    output [7:0] out // 8-bit output
);

reg [7:0] state; // Internal register to hold the current state

// Initialize the output with the initial state
initial out = 8'b0000_0001;

// Procedural block to update the state at each rising edge of the clock
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the state to the initial state when reset is high
        state <= 8'b0000_0001;
    end else begin
        // Update the state according to the cyclic pattern
        // Shift the '1' to the next bit position, and wrap around when necessary
        if (state == 8'b1000_0000) begin
            state <= 8'b0000_0001; // Wrap around to the LSB
        end else begin
            state <= (state << 1); // Shift the '1' to the next bit position
        end
    end
end

// Continuous assignment to drive the output with the current state
assign out = state;

endmodule