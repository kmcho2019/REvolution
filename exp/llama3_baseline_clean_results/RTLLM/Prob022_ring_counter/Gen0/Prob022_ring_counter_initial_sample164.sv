module ring_counter(
    input           clk,    // Clock signal
    input           reset,  // Reset signal
    output reg [7:0] out    // 8-bit output
);

// Initialize the ring counter to its starting state on reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001;  // Reset state with LSB set to 1
    end else begin
        // Shift the bits to the left, wrapping the MSB back to the LSB
        out <= {out[6:0], out[7]};
    end
end

endmodule