module ring_counter(
    input clk,         // Clock signal
    input reset,       // Reset signal
    output reg [7:0] out // 8-bit output representing the current state
);

// Initialize the output to its starting state when reset is high
always @(*) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize with LSB set to 1
    end
end

// Update the output on each rising edge of the clock signal
always @(posedge clk) begin
    if (~reset) begin
        out <= {out[6:0], out[7]}; // Shift the bits to the right and wrap the MSB to LSB
    end else begin
        out <= 8'b0000_0001; // If reset is high, reset the counter to its initial state
    end
end

endmodule