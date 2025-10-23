module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos; // 3 bits to represent 8 positions

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize out to starting state when reset is high
        pos <= 0; // Initialize position to 0
    end else begin
        pos <= (pos + 1) % 8; // Increment position and wrap around to 0 after 7
        out <= 1 << pos; // Shift the '1' to the next position
    end
end

endmodule