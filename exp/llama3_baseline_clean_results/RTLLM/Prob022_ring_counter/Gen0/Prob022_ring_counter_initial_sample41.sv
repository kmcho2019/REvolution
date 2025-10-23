module ring_counter(
    input           clk,      // Clock signal
    input           reset,    // Reset signal
    output reg [7:0] out       // 8-bit output representing the current state
);

// Internal state register
reg [7:0] state;

// Initialize the state register on reset
always @(posedge reset or posedge clk) begin
    if (reset) begin
        state <= 8'b0000_0001; // Initialize to starting state
    end else begin
        // Update the state on each rising edge of the clock
        state <= {state[6:0], state[7]}; // Shift the 1 bit to the next position
    end
end

// Assign the current state to the output
always @(*) begin
    out <= state;
end

endmodule