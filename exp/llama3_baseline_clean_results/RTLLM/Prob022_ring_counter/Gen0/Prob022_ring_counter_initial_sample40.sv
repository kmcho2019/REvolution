module ring_counter(
    input clk,        // Clock signal
    input reset,      // Reset signal
    output reg [7:0] out // 8-bit output
);

// Initialize the ring counter with the LSB set to 1
initial begin
    out = 8'b0000_0001;
end

// Synchronize state transitions with the rising edge of the clock signal
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the ring counter to its initial state
        out <= 8'b0000_0001;
    end else begin
        // Shift the output to the left by one bit to move the '1' to the next position
        // and add the MSB to the LSB to create the cyclic behavior
        out <= {out[6:0], out[7]};
    end
end

endmodule