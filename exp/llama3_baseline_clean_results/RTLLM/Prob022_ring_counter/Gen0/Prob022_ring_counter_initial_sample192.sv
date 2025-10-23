module ring_counter (
    input  wire        clk,     // Clock signal
    input  wire        reset,   // Reset signal
    output reg  [7:0]  out      // 8-bit output representing the current state
);

// Initialize the output to its starting state when reset is high
always @ (posedge reset) begin
    out <= 8'b0000_0001;  // Initialize to the least significant bit
end

// Update the state on each rising edge of the clock signal
always @ (posedge clk) begin
    if (!reset) begin
        // Shift the '1' bit to the next position in the sequence
        out <= {out[6:0], out[7]};  // Rotate the bits to the left and wrap around
    end
end

endmodule