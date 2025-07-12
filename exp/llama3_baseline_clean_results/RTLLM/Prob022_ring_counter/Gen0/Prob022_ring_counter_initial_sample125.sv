module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

// Initialize the counter to its starting state when reset is high
always @ (posedge reset) begin
    out <= 8'b0000_0001; // Reset to the least significant bit set to 1
end

// Update the counter state on each rising edge of the clock signal
always @ (posedge clk) begin
    if (!reset) begin
        // Shift the current state to the left and wrap around to the least significant bit
        out <= {out[6:0], out[7]};
    end
end

endmodule