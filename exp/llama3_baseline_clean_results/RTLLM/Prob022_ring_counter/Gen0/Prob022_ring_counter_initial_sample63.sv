module ring_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    output reg [7:0] out // 8-bit output representing the current state
);

// Initialize the counter to its starting state when reset is high
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to its starting state
        out <= 8'b0000_0001;
    end else begin
        // Shift the 1 to the next bit with each clock pulse
        out <= {out[6:0], out[7]};
    end
end

endmodule