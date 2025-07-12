module ring_counter(
    input           clk,     // Clock signal
    input           reset,   // Reset signal
    output reg [7:0] out     // 8-bit output representing the current state
);

// Initialize the output to its starting state when reset is high
always @(posedge reset) begin
    out <= 8'b0000_0001;
end

// Update the state of the ring counter at each rising edge of the clock signal
always @(posedge clk) begin
    if (~reset) begin
        // Perform a cyclic shift of the 1 bit to the next position
        out <= {out[6:0], out[7]};
    end
end

endmodule