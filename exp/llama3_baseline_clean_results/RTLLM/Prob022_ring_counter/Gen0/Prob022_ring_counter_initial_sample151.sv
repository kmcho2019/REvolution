module ring_counter (
    input clk,        // Clock signal
    input reset,      // Reset signal
    output [7:0] out  // 8-bit output representing the current state
);

reg [7:0] state;     // Internal register to hold the current state

// Initialize the output based on the internal state
assign out = state;

// Update the internal state based on the clock and reset signals
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to its starting state
        state <= 8'b0000_0001;
    end else begin
        // Shift the current state one position to the right in a circular manner
        state <= {state[6:0], state[7]};
    end
end

endmodule