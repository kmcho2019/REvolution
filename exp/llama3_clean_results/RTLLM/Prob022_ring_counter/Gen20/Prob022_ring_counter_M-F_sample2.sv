// Module: ring_counter
// Description: An 8-bit ring counter that cyclically shifts a high bit through its output.
// Parameters:
//   - clk: Clock signal for state transitions
//   - reset: Reset signal to initialize the counter
//   - out: 8-bit output where exactly one bit is high at any time, cycling through the bits

module ring_counter(
    input clk, // Clock signal
    input reset, // Reset signal
    output reg [7:0] out // 8-bit output
);

reg [2:0] state; // 3-bit state variable to track the current position

// Update state on rising edge of clk, reset when reset is high
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize state to 0 when reset is high
        state <= 3'b000;
    end else begin
        // Increment state, wrapping around at 8
        state <= (state + 1) % 8;
    end
end

// Generate output based on current state using bitwise shift
always @(state) begin
    // Use bitwise left shift to set the bit corresponding to the current state
    out <= 1 << state;
end

endmodule