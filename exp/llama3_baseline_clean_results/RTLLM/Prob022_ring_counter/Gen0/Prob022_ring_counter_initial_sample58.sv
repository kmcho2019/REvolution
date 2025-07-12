module ring_counter(
    input           clk,    // Clock signal
    input           reset,  // Reset signal
    output reg [7:0] out    // 8-bit output
);

// Initialize the output to its starting state when reset is high
always @(posedge reset) begin
    out <= 8'b0000_0001;  // Set the least significant bit to 1
end

// Update the output on each rising edge of the clock signal
always @(posedge clk) begin
    if (!reset) begin  // If reset is not high, update the output
        // Shift the bits of the output to the left and wrap the most significant bit around to the least significant bit
        out <= {out[6:0], out[7]};
    end else begin
        // If reset is high, keep the output in its initial state
        out <= 8'b0000_0001;
    end
end

endmodule