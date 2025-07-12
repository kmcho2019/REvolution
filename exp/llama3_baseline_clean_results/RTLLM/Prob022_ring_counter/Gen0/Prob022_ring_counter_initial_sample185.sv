module ring_counter(
    input         clk,    // Clock signal
    input         reset,  // Reset signal
    output reg [7:0] out   // 8-bit output representing the current state
);

    // Initialize the counter to its starting state on reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the counter to its initial state with LSB set to 1
            out <= 8'b0000_0001;
        end else begin
            // Update the counter state on each clock pulse
            // Shift the '1' bit to the next position, wrapping around to LSB after MSB
            out <= {out[6:0], out[7]};
        end
    end

endmodule