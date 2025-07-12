module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

// Initialize the output to its starting state when reset is high
always @(*) begin
    if (reset) begin
        out <= 8'b0000_0001;
    end
end

// Update the output on each rising edge of the clock signal
always @(posedge clk) begin
    if (~reset) begin
        // Shift the set bit to the next position, wrapping around to the LSB after the MSB
        out <= {out[6:0], out[7]};
    end else begin
        // Reset the counter to its initial state
        out <= 8'b0000_0001;
    end
end

endmodule