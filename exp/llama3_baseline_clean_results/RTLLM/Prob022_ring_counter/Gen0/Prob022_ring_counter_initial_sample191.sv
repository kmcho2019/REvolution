module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the counter to its starting state when reset is high
        out <= 8'b0000_0001;
    end else begin
        // Shift the set bit to the next position on each clock pulse
        if (out == 8'b1000_0000) begin
            // Wrap around to the LSB when the set bit reaches the MSB
            out <= 8'b0000_0001;
        end else begin
            // Shift the set bit to the next position
            out <= out << 1;
        end
    end
end

endmodule