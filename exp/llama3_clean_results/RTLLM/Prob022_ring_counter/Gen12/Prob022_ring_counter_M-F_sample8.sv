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
        case (pos)
            3'b000: out <= 8'b0000_0001; // Position 0
            3'b001: out <= 8'b0000_0010; // Position 1
            3'b010: out <= 8'b0000_0100; // Position 2
            3'b011: out <= 8'b0000_1000; // Position 3
            3'b100: out <= 8'b0001_0000; // Position 4
            3'b101: out <= 8'b0010_0000; // Position 5
            3'b110: out <= 8'b0100_0000; // Position 6
            3'b111: out <= 8'b1000_0000; // Position 7
        endcase
    end
end

endmodule