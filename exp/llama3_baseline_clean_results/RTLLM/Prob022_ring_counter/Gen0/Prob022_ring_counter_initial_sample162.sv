module ring_counter(
    input clk,         // Clock signal
    input reset,       // Reset signal
    output reg [7:0] out // 8-bit output
);

// Initialize the counter to its starting state when reset is high
always @(*) begin
    if(reset) begin
        out <= 8'b0000_0001; // Reset to the starting state with LSB set to 1
    end
end

// Update the counter state on each rising edge of the clock
always @(posedge clk) begin
    if(!reset) begin
        // Perform a cyclic shift to move the set bit to the next position
        if(out == 8'b1000_0000) begin // Check if we're at the MSB
            out <= 8'b0000_0001; // Wrap around to the LSB
        end else begin
            out <= {out[6:0], out[7]}; // Shift the set bit to the next position
        end
    end
end

endmodule