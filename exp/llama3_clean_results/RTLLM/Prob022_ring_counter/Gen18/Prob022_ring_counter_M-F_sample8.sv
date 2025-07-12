module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos; // 3 bits to represent 8 positions

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 0; // Initialize to starting position when reset is high
        out <= 1'b1 << pos; // Initialize out to 1 at the LSB when reset is high
    end else begin
        pos <= (pos + 1) % 8; // Increment position and wrap around to 0 after 7
        out <= 1'b1 << pos; // Set the bit at position pos to 1 and all others to 0
    end
end

endmodule