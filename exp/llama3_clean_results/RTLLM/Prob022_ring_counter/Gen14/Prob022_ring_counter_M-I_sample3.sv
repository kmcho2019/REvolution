module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos; // 3 bits to represent 8 positions

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 0; // Initialize to starting position when reset is high
        out <= 8'b0000_0001; // Reset out to initial state (LSB is 1)
    end else begin
        pos <= (pos + 1) % 8; // Increment position and wrap around to 0 after 7
        out <= 1 << pos; // Directly assign the result to out, which sets the bit at position pos to '1'
    end
end

endmodule