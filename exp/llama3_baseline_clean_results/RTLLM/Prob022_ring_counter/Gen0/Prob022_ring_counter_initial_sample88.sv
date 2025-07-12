module ring_counter(
    input           clk,        // Clock signal
    input           reset,      // Reset signal
    output [7:0]    out         // 8-bit output
);

reg [7:0] state;  // Internal state register

// Initialize the output with a default value to avoid latch inference
initial out = 8'b0;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the state to the starting state when reset is high
        state <= 8'b0000_0001;
    end else begin
        // Update the state by shifting the 1 to the next position
        state <= {state[6:0], state[7]};
    end
end

// Assign the internal state to the output
assign out = state;

endmodule