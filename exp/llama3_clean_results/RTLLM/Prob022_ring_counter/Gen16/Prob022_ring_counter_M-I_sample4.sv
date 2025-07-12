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
        pos <= (pos == 7)? 0 : pos + 1; // Wrap around to 0 after 7
        out <= 1 << pos; // Set the correct bit high based on position 'pos'
    end
end

endmodule