module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b00000001;  // Initialize with LSB set
    end
    else begin
        // Circular shift left using bitwise OR
        // When MSB is set, (out >> 7) becomes 1, creating wrap-around
        out <= (out << 1) | (out >> 7);
    end
end

endmodule