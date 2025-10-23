module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos; // 3 bits to represent 8 positions

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 0; // Reset position to 0
        out <= 8'b0000_0001; // Reset out to starting state
    end else begin
        if (pos == 7) begin
            pos <= 0; // Wrap around to 0 after 7
        end else begin
            pos <= pos + 1; // Increment position
        end
        out <= 1 << pos; // Update out directly based on pos
    end
end

endmodule