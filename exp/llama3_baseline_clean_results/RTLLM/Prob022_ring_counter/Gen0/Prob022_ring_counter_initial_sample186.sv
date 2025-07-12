module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

// Initialize the output to the starting state
initial out = 8'b0000_0001;

// Update the output on each rising edge of the clock signal
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to its starting state
        out <= 8'b0000_0001;
    end else begin
        // Shift the set bit to the next position
        out <= {out[6:0], out[7]};
    end
end

endmodule