module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos; // 3 bits to represent 8 positions

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 0; // Initialize to starting position when reset is high
    end else begin
        pos <= (pos + 1) % 8; // Increment position and wrap around to 0 after 7
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset out to initial state
    end else begin
        out <= 8'b0; // Clear all bits
        out[pos] <= 1'b1; // Set the bit at current position to 1
    end
end

endmodule