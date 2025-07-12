module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

// Initialize the ring counter with the LSB set to 1
initial out = 8'b0000_0001;

// Update the ring counter state on each rising edge of the clock signal
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the ring counter to its initial state
        out <= 8'b0000_0001;
    end else begin
        // Shift the current state one bit to the right
        out <= {out[6:0], out[7]};
    end
end

endmodule