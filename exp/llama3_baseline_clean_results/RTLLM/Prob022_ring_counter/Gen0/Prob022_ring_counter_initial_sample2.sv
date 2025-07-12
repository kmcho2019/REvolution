module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

// Initialize the ring counter to its starting state when reset is high
always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize with LSB set to 1
    end else begin
        // Shift the current state one bit to the right and wrap around to the LSB when reaching the MSB
        out <= {out[6:0], out[7]}; 
    end
end

endmodule