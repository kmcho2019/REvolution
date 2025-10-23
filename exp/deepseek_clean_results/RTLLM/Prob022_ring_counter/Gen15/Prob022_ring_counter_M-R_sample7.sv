module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

reg [2:0] pos;  // Position counter (0-7)

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pos <= 3'b000;  // Reset to position 0 (LSB)
    end else begin
        pos <= pos + 1;  // Increment position (automatically wraps around)
    end
end

always @(*) begin
    out = 8'b00000000;  // Default all zeros
    out[pos] = 1'b1;    // Set the current position bit
end

endmodule