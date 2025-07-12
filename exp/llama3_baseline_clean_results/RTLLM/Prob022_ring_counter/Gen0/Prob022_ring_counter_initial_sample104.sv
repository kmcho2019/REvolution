module ring_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    output [7:0] out // 8-bit output
);

reg [7:0] state; // Internal state register

// Initialize state to the starting state when reset is high
always @(posedge reset or posedge clk) begin
    if (reset) begin
        state <= 8'b0000_0001; // Initialize to starting state with LSB set to 1
    end else begin
        // Shift the bits one position to the right and wrap the MSB around to the LSB
        state <= {state[6:0], state[7]};
    end
end

// Assign the current state to the output
assign out = state;

endmodule