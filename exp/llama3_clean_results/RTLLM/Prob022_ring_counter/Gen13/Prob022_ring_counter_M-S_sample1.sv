module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos = 0; // Position variable to keep track of the '1'

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 0; // Reset position to 0
        out <= 8'b0000_0001; // Reset output to initial state
    end else begin
        pos <= (pos + 1) % 8; // Increment position and wrap around
        out <= 1 << pos; // Set the bit at the current position to 1
    end
end

endmodule