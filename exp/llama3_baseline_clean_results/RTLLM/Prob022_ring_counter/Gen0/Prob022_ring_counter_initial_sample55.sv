module ring_counter(
    input           clk,    // Clock signal
    input           reset,  // Reset signal
    output reg [7:0] out     // 8-bit output
);

// Initialize the counter to its starting state when reset is high
always @(*) begin
    if (reset) begin
        out <= 8'b0000_0001;  // Reset state: out = 8'b0000_0001
    end
end

// Update the counter state on each rising edge of the clock signal
always @(posedge clk) begin
    if (!reset) begin
        // Shift the current state one bit to the right and set the LSB to the MSB
        out <= {out[6:0], out[7]};  // Cyclic shift to the right
    end else begin
        out <= 8'b0000_0001;  // Reset state: out = 8'b0000_0001
    end
end

endmodule