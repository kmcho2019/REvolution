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
        // Perform a cyclic shift of the bits in the out array
        // Shift the current state one bit to the right and wrap around
        reg [7:0] temp;
        temp = out;
        for (int i = 7; i > 0; i--) begin
            out[i] <= temp[i-1];
        end
        // Wrap around to the LSB
        out[0] <= temp[7];
    end
end

endmodule